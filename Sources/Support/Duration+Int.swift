//
//  Double+Duration.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/5/25.
//

import Foundation

extension Duration {
    /// Seconds in the `Duration` as `Double`.
    var secondsInt: Double { Double(components.seconds) }
}
