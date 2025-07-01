//
//  Playlist.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import Foundation

struct Playlist: Sendable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let videos: [Video]
    let spec: PlaylistSpec

    /// Stored override when user navigates; `nil` means "use default".
    private var _bookmark: Bookmark? = nil

    /// Bookmark is either custom or derived lazily from the first video.
    var bookmark: Bookmark {
        get {
            _bookmark ?? videos.first.map { Bookmark(video: $0) }
                ?? .none
        }
        set { _bookmark = newValue }
    }

    // MARK: - Init
    /// Member-wise initializer that hides the private backing bookmark.
    init(
        id: String,
        name: String,
        videos: [Video],
        spec: PlaylistSpec,
        bookmark: Bookmark? = nil
    ) {
        self.id = id
        self.name = name
        self.videos = videos
        self.spec = spec
        self._bookmark = bookmark
    }

    struct Bookmark: Sendable, Codable, Equatable, Hashable {
        var video: Video

        /// Seconds offset is stored inside the video.
        var seconds: Double {
            get { video.startAt }
            set { video.startAt = newValue }
        }

        /// Null object – represents no selection.
        static let none = Bookmark(video: .none)
    }
}
