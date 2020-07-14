// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: BuildSystem/Execution/action.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

// This source file is part of the Swift.org open source project
//
// Copyright (c) 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import Foundation
import SwiftProtobuf

import TSFCAS
import llbuild2

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// Key that represents the evaluation of an action's outputs. The inputs to this action have not been resolved at this
/// stage, so the purpose of the ActionFunction is to resolve the inputs and request the execution of the action.
public struct LLBActionKey {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Represents what type of action this key represents.
  public var actionType: LLBActionKey.OneOf_ActionType? = nil

  /// A command line based action key.
  public var command: LLBCommandAction {
    get {
      if case .command(let v)? = actionType {return v}
      return LLBCommandAction()
    }
    set {actionType = .command(newValue)}
  }

  /// A merge trees based action key.
  public var mergeTrees: LLBMergeTreesAction {
    get {
      if case .mergeTrees(let v)? = actionType {return v}
      return LLBMergeTreesAction()
    }
    set {actionType = .mergeTrees(newValue)}
  }

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Represents what type of action this key represents.
  public enum OneOf_ActionType: Equatable {
    /// A command line based action key.
    case command(LLBCommandAction)
    /// A merge trees based action key.
    case mergeTrees(LLBMergeTreesAction)

  #if !swift(>=4.1)
    public static func ==(lhs: LLBActionKey.OneOf_ActionType, rhs: LLBActionKey.OneOf_ActionType) -> Bool {
      switch (lhs, rhs) {
      case (.command(let l), .command(let r)): return l == r
      case (.mergeTrees(let l), .mergeTrees(let r)): return l == r
      default: return false
      }
    }
  #endif
  }

  public init() {}
}

/// The value for an ActionKey.
public struct LLBActionValue {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The list of outputs IDs that the action produced. This will be in the same order as requested in
  /// actionType.
  public var outputs: [TSFCAS.LLBDataID] = []

  /// The data ID for the stdout of the action.
  public var stdoutID: TSFCAS.LLBDataID {
    get {return _stdoutID ?? TSFCAS.LLBDataID()}
    set {_stdoutID = newValue}
  }
  /// Returns true if `stdoutID` has been explicitly set.
  public var hasStdoutID: Bool {return self._stdoutID != nil}
  /// Clears the value of `stdoutID`. Subsequent reads from it will return its default value.
  public mutating func clearStdoutID() {self._stdoutID = nil}

  /// The data ID for the stderr of the action.
  public var stderrID: TSFCAS.LLBDataID {
    get {return _stderrID ?? TSFCAS.LLBDataID()}
    set {_stderrID = newValue}
  }
  /// Returns true if `stderrID` has been explicitly set.
  public var hasStderrID: Bool {return self._stderrID != nil}
  /// Clears the value of `stderrID`. Subsequent reads from it will return its default value.
  public mutating func clearStderrID() {self._stderrID = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _stdoutID: TSFCAS.LLBDataID? = nil
  fileprivate var _stderrID: TSFCAS.LLBDataID? = nil
}

/// An action execution description for a command line invocation.
public struct LLBCommandAction {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The spec for the action to execute.
  public var actionSpec: llbuild2.LLBActionSpec {
    get {return _actionSpec ?? llbuild2.LLBActionSpec()}
    set {_actionSpec = newValue}
  }
  /// Returns true if `actionSpec` has been explicitly set.
  public var hasActionSpec: Bool {return self._actionSpec != nil}
  /// Clears the value of `actionSpec`. Subsequent reads from it will return its default value.
  public mutating func clearActionSpec() {self._actionSpec = nil}

  /// The list of artifact inputs required for this action evaluation.
  public var inputs: [LLBArtifact] = []

  /// The list of outputs expected from this action evaluation.
  public var outputs: [llbuild2.LLBActionOutput] = []

  /// Identifier for the dynamic action executor for this action. Should be empty for the vast majority of the cases,
  /// and only be used for actions that schedule additional actions based on the outputs of previous actions.
  public var dynamicIdentifier: String = String()

  /// Identifier for the type of action this represents. This is only used for display and metrics purposes, it has no
  /// effect in how the action is executed (but is considered to be part of the action key so changes to it invalidate
  /// the action).
  public var mnemonic: String = String()

  /// A user presentable description for the action, can be used to display currently running actions in a UX friendly
  /// manner.
  public var description_p: String = String()

  /// Whether the action should be cached even if it resulted in an error. This can be useful in cases where large
  /// actions are skipped if it has already been tried, in a context where it is known that the action is
  /// deterministic. Most of the time this should be unset.
  public var cacheableFailure: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _actionSpec: llbuild2.LLBActionSpec? = nil
}

/// An action that merges artifacts into a single tree artifact. There is no output specification since that lies in the
/// artifact itself. The ActionValue will have a single dataID as output corresponding to the dataID of the tree
/// artifact containing the inputs. If there are tree artifacts with colliding subdirectories, they will be merged. For
/// colliding files, the last one "wins".
public struct LLBMergeTreesAction {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The list of inputs into the merge action. Each input contains the artifact to merge and the root it should be
  /// merged under.
  public var inputs: [LLBMergeTreesActionInput] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

/// A single input into a merge trees action.
public struct LLBMergeTreesActionInput {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The artifact to merge into a tree. It can be any kind of artifact.
  public var artifact: LLBArtifact {
    get {return _artifact ?? LLBArtifact()}
    set {_artifact = newValue}
  }
  /// Returns true if `artifact` has been explicitly set.
  public var hasArtifact: Bool {return self._artifact != nil}
  /// Clears the value of `artifact`. Subsequent reads from it will return its default value.
  public mutating func clearArtifact() {self._artifact = nil}

  /// The path under which the artifact should be placed. For instance, if artifact points to a file, and path points
  /// to `some/path`, then the merge trees action output will contain the file at that path. Note that this overrides
  /// the artifact's own path. If you'd like to preserve the path of the artifact in the output directory tree, set
  /// path to the artifact's path.
  public var path: String = String()

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _artifact: LLBArtifact? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension LLBActionKey: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "LLBActionKey"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "command"),
    2: .same(proto: "mergeTrees"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1:
        var v: LLBCommandAction?
        if let current = self.actionType {
          try decoder.handleConflictingOneOf()
          if case .command(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.actionType = .command(v)}
      case 2:
        var v: LLBMergeTreesAction?
        if let current = self.actionType {
          try decoder.handleConflictingOneOf()
          if case .mergeTrees(let m) = current {v = m}
        }
        try decoder.decodeSingularMessageField(value: &v)
        if let v = v {self.actionType = .mergeTrees(v)}
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    switch self.actionType {
    case .command(let v)?:
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    case .mergeTrees(let v)?:
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    case nil: break
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: LLBActionKey, rhs: LLBActionKey) -> Bool {
    if lhs.actionType != rhs.actionType {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension LLBActionValue: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "LLBActionValue"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "outputs"),
    2: .same(proto: "stdoutID"),
    3: .same(proto: "stderrID"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.outputs)
      case 2: try decoder.decodeSingularMessageField(value: &self._stdoutID)
      case 3: try decoder.decodeSingularMessageField(value: &self._stderrID)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.outputs.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.outputs, fieldNumber: 1)
    }
    if let v = self._stdoutID {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    if let v = self._stderrID {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: LLBActionValue, rhs: LLBActionValue) -> Bool {
    if lhs.outputs != rhs.outputs {return false}
    if lhs._stdoutID != rhs._stdoutID {return false}
    if lhs._stderrID != rhs._stderrID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension LLBCommandAction: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "LLBCommandAction"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "actionSpec"),
    2: .same(proto: "inputs"),
    3: .same(proto: "outputs"),
    4: .same(proto: "dynamicIdentifier"),
    5: .same(proto: "mnemonic"),
    6: .same(proto: "description"),
    7: .same(proto: "cacheableFailure"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularMessageField(value: &self._actionSpec)
      case 2: try decoder.decodeRepeatedMessageField(value: &self.inputs)
      case 3: try decoder.decodeRepeatedMessageField(value: &self.outputs)
      case 4: try decoder.decodeSingularStringField(value: &self.dynamicIdentifier)
      case 5: try decoder.decodeSingularStringField(value: &self.mnemonic)
      case 6: try decoder.decodeSingularStringField(value: &self.description_p)
      case 7: try decoder.decodeSingularBoolField(value: &self.cacheableFailure)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._actionSpec {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.inputs.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.inputs, fieldNumber: 2)
    }
    if !self.outputs.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.outputs, fieldNumber: 3)
    }
    if !self.dynamicIdentifier.isEmpty {
      try visitor.visitSingularStringField(value: self.dynamicIdentifier, fieldNumber: 4)
    }
    if !self.mnemonic.isEmpty {
      try visitor.visitSingularStringField(value: self.mnemonic, fieldNumber: 5)
    }
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 6)
    }
    if self.cacheableFailure != false {
      try visitor.visitSingularBoolField(value: self.cacheableFailure, fieldNumber: 7)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: LLBCommandAction, rhs: LLBCommandAction) -> Bool {
    if lhs._actionSpec != rhs._actionSpec {return false}
    if lhs.inputs != rhs.inputs {return false}
    if lhs.outputs != rhs.outputs {return false}
    if lhs.dynamicIdentifier != rhs.dynamicIdentifier {return false}
    if lhs.mnemonic != rhs.mnemonic {return false}
    if lhs.description_p != rhs.description_p {return false}
    if lhs.cacheableFailure != rhs.cacheableFailure {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension LLBMergeTreesAction: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "LLBMergeTreesAction"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "inputs"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.inputs)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.inputs.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.inputs, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: LLBMergeTreesAction, rhs: LLBMergeTreesAction) -> Bool {
    if lhs.inputs != rhs.inputs {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension LLBMergeTreesActionInput: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "LLBMergeTreesActionInput"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "artifact"),
    2: .same(proto: "path"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularMessageField(value: &self._artifact)
      case 2: try decoder.decodeSingularStringField(value: &self.path)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._artifact {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.path.isEmpty {
      try visitor.visitSingularStringField(value: self.path, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: LLBMergeTreesActionInput, rhs: LLBMergeTreesActionInput) -> Bool {
    if lhs._artifact != rhs._artifact {return false}
    if lhs.path != rhs.path {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
