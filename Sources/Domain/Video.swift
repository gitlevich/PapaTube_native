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
    let duration: String
    let url: String
    let publishedAt: Date
}

extension Video {
    /// A stable singleton representing the absence of a real `Video` value – useful for default bindings.
    static let none = Video(
        youtubeId:    "",
        title:        "",
        thumbnailUrl: "",
        duration:     "0",
        url:          "",
        publishedAt:  .distantPast
    )

    /// Convenience flag: `true` when this instance equals `Video.none`.
    var isNone: Bool { self == .none }
}
