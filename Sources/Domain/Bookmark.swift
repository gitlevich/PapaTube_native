//
//  Bookmark.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/1/25.
//


import Foundation

struct Bookmark: Sendable, Codable, Equatable, Hashable {
    var video: Video

    /// Seconds offset is stored inside the video.
    var seconds: Int {
        get { video.startAt }
        set { video.startAt = newValue }
    }

    /// Null object – represents no selection.
    static let none = Bookmark(video: .none)
}
