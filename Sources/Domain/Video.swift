//
//  Video.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import Foundation

struct Video: Sendable, Codable, Hashable, Equatable {
    let youtubeId: String
    let title: String
    let thumbnailUrl: String
    let duration: Duration
    let url: String
    let publishedAt: Date
    
    /// Returns watch progress as a `Percent` using integer arithmetic.
    /// Traps if duration is zero.
    func progressAt(second: Int) -> Double {
        Double(second) * 100 / duration.secondsInt
    }
    
    /// Returns the seconds from start based on progress.
    func secondsFromStart(at progress: Double) -> Int {
        precondition((0...1).contains(progress), "Progress myst be between 0 and 1")
        return Int((progress * duration.secondsInt).rounded())
    }
    
    /// A stable singleton representing the absence of a real `Video` value – useful for default bindings.
    static let none = Video(
        youtubeId:    "",
        title:        "",
        thumbnailUrl: "",
        duration:     Duration.seconds(60),
        url:          "",
        publishedAt:  .distantPast
    )

    /// Convenience flag: `true` when this instance equals `Video.none`.
    var isNone: Bool { self == .none }
}


