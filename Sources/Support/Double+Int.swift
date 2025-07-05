//
//  Double+Int.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/4/25.
//

private extension Double {
    /// Converts a 0…1 progress value into seconds offset from the start.
    /// - Parameter total: total duration in seconds.
    /// - Returns: whole‑second offset from the start.
    /// - Precondition: `self` must be in 0…1 and `total` ≥ 0.
    func seconds(from total: Int) -> Int {
        precondition((0...1).contains(self), "Progress must be between 0 and 1")
        precondition(total >= 0, "Duration must be non‑negative")
        return Int((self * Double(total)).rounded())
    }
}
