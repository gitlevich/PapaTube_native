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
    let duration: Duration   // ISO-8601 string as returned by YouTube API (e.g. "PT3M42S")
    let url: String
    let publishedAt: Date
    
    /// Returns watch progress as a `Percent` using integer arithmetic.
    /// Traps if duration is zero.
    func progressAt(second: Int) -> Double {
        Double(second) * 100 / duration.secondsInt
    }
}

extension Video {
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

extension Duration {
    /// Seconds in the `Duration` as `Double`.
    var secondsInt: Double { Double(components.seconds) }
}

