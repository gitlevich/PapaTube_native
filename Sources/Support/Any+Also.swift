//
//  Any+Also.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/4/25.
//

import Foundation

/// Opt‑in mix‑in that adds Kotlin‑style `also { ... }` to conforming types.
public protocol Also {}

public extension Also {
  /// Executes `block` with `self` and returns `self`, mirroring Kotlin’s `also`.
  @discardableResult
  func also(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
}

/// Automatically adopts `Also` for every `NSObject` subclass so all reference
/// types get the helper without extra boilerplate.
/// For value‑types (`struct` / `enum`), declare `extension MyType: Also {}`.
extension NSObject: Also {}
