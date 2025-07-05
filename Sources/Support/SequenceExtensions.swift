//
//  SequenceExtensions.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/4/25.
//


// MARK: - Sequence helper
extension Sequence {
    /// Returns an array of `(Element, Int)` tuples pairing each element with its index.
    func mapIndexed() -> [(Element, Int)] {
        enumerated().map { (idx, element) in (element, idx) }
    }
}
