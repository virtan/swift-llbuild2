// This source file is part of the Swift.org open source project
//
// Copyright (c) 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import llbuild2
import LLBBuildSystem
import LLBBuildSystemTestHelpers
import TSCBasic
import XCTest

struct PlatformFragmentKey: LLBConfigurationFragmentKey, Codable, Hashable {
    static let identifier = String(describing: Self.self)

    let platformName: String

    init(platformName: String) {
        self.platformName = platformName
    }

    public var stableHashValue: LLBDataID {
        return LLBDataID(blake3hash: platformName)
    }
}

struct PlatformFragment: LLBConfigurationFragment, Codable {
    let expensiveCompilerPath: String

    init(expensiveCompilerPath: String) {
        self.expensiveCompilerPath = expensiveCompilerPath
    }
}

private final class PlatformFragmentFunction: LLBBuildFunction<PlatformFragmentKey, PlatformFragment> {
    override func evaluate(key: PlatformFragmentKey, _ fi: LLBBuildFunctionInterface, _ ctx: Context) -> LLBFuture<PlatformFragment> {
        return ctx.group.next().makeSucceededFuture(
            PlatformFragment(expensiveCompilerPath: "expensive_compiler_path_for_\(key.platformName)")
        )
    }
}

fileprivate struct ConfigurationTestsProvider: LLBProvider, Codable {
    let simpleString: String

    init(simpleString: String) {
        self.simpleString = simpleString
    }
}

private struct ConfigurationTestsConfiguredTarget: LLBConfiguredTarget, Codable {
    let name: String
    let dependency: LLBLabel?
    let configurationType: String?

    init(name: String, dependency: LLBLabel? = nil, configurationType: String? = nil) {
        self.name = name
        self.dependency = dependency
        self.configurationType = configurationType
    }
    
    var targetDependencies: [String : LLBTargetDependency] {
        if let dependency = dependency, let configurationType = configurationType {
            let configurationKey = try? LLBConfigurationKey(fragmentKeys: [PlatformFragmentKey(platformName: configurationType)])
            return ["dependency": .single(dependency, configurationKey)]
        }
        return [:]
    }
}

private final class ConfigurationTestsBuildRule: LLBBuildRule<ConfigurationTestsConfiguredTarget> {
    override func evaluate(configuredTarget: ConfigurationTestsConfiguredTarget, _ ruleContext: LLBRuleContext) throws -> LLBFuture<[LLBProvider]> {
        var returnValue = ""
        let platformConfiguration = try ruleContext.getFragment(PlatformFragment.self)
        returnValue += platformConfiguration.expensiveCompilerPath

        if let provider: ConfigurationTestsProvider = try? ruleContext.getProvider(for: "dependency") {
            returnValue += "-\(provider.simpleString)"
        }

        return ruleContext.group.next().makeSucceededFuture([ConfigurationTestsProvider(simpleString: returnValue)])
    }
}

private final class ConfigurationTestsConfiguredTargetDelegate: LLBConfiguredTargetDelegate {
    func configuredTarget(for key: LLBConfiguredTargetKey, _ fi: LLBBuildFunctionInterface, _ ctx: Context) throws -> LLBFuture<LLBConfiguredTarget> {

        let configuredTarget: ConfigurationTestsConfiguredTarget
        if key.label.targetName == "top_level_target", try key.configurationKey.get(PlatformFragmentKey.self).platformName == "target" {
            configuredTarget = ConfigurationTestsConfiguredTarget(
                name: key.label.targetName,
                dependency: try LLBLabel("//some:top_level_target"),
                configurationType: "host"
            )
        } else {
            configuredTarget = ConfigurationTestsConfiguredTarget(name: key.label.targetName)
        }

        return ctx.group.next().makeSucceededFuture(configuredTarget)
    }
}

private final class ConfigurationTestsRuleLookupDelegate: LLBRuleLookupDelegate {
    let ruleMap: [String: LLBRule] = [
        ConfigurationTestsConfiguredTarget.identifier: ConfigurationTestsBuildRule(),
    ]

    func rule(for configuredTargetType: LLBConfiguredTarget.Type) -> LLBRule? {
        return ruleMap[configuredTargetType.identifier]
    }
}

class ConfigurationTestsFunctionMap: LLBBuildFunctionLookupDelegate {
    let functionMap: [LLBBuildKeyIdentifier: LLBFunction]

    init() {
        self.functionMap = [
            PlatformFragmentKey.identifier: PlatformFragmentFunction(),
        ]
    }

    func lookupBuildFunction(for identifier: LLBBuildKeyIdentifier) -> LLBFunction? {
        return self.functionMap[identifier]
    }
}


class ConfigurationTests: XCTestCase {
    // This test requires a lot of setup, but effectively it's testing that configuration transitions result in the same
    // target (as represented by the label) gets evaluated for each configuration encountered during the build. You can
    // see this by the assert at the end, where the final `simpleString` contains references to the target configuration
    // and the host configuration.
    // This works more as an integration test, since it enforces the functionalities of most of the build system to
    // achieve this result. Real life clients of llbuild2 will need to provide similar infrastructure (in a more
    // sustainable approach of course).
    func testSameTargetConfigurationTransitions() throws {
        try withTemporaryDirectory { tempDir in
            let configuredTargetDelegate = ConfigurationTestsConfiguredTargetDelegate()
            let ruleLookupDelegate = ConfigurationTestsRuleLookupDelegate()
            let ctx = LLBMakeTestContext()
            let testEngine = LLBTestBuildEngine(
                group: ctx.group,
                db: ctx.db,
                buildFunctionLookupDelegate: ConfigurationTestsFunctionMap(),
                configuredTargetDelegate: configuredTargetDelegate,
                ruleLookupDelegate: ruleLookupDelegate
            ) { registry in
                registry.register(type: PlatformFragmentKey.self)
                registry.register(type: PlatformFragment.self)
                registry.register(type: ConfigurationTestsConfiguredTarget.self)
            }

            let dataID = try LLBCASFileTree.import(path: tempDir, to: ctx.db, ctx).wait()

            let label = try LLBLabel("//some:top_level_target")
            let configurationKey = try LLBConfigurationKey(fragmentKeys: [PlatformFragmentKey(platformName: "target")])
            let configuredTargetKey = LLBConfiguredTargetKey(rootID: dataID, label: label, configurationKey: configurationKey)

            let evaluatedTargetKey = LLBEvaluatedTargetKey(configuredTargetKey: configuredTargetKey)

            let evaluatedTargetValue: LLBEvaluatedTargetValue = try testEngine.build(evaluatedTargetKey, ctx).wait()

            let simpleString = try evaluatedTargetValue.providerMap.get(ConfigurationTestsProvider.self).simpleString

            XCTAssertEqual(simpleString, "expensive_compiler_path_for_target-expensive_compiler_path_for_host")
        }
    }
}
