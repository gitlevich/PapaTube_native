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
    let duration: String   // ISO-8601 string as returned by YouTube API (e.g. "PT3M42S")
    let url: String
    let publishedAt: Date
    var startAt: Int = 0          // seconds offset where playback should start (default 0)
}

extension Video {
    /// A stable singleton representing the absence of a real `Video` value – useful for default bindings.
    static let none = Video(
        youtubeId:    "",
        title:        "",
        thumbnailUrl: "",
        duration:     "0",
        url:          "",
        publishedAt:  .distantPast,
        startAt:      0
    )

    /// Convenience flag: `true` when this instance equals `Video.none`.
    var isNone: Bool { self == .none }
}
