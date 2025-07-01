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

    // MARK: - Navigation helpers

    /// Index of the current bookmark in `videos`, or `nil` when no video is selected.
    private var currentIndex: Int? {
        videos.firstIndex(of: bookmark.video)
    }

    /// `true` when there is a previous video available.
    func hasPrev() -> Bool {
        guard let idx = currentIndex else { return false }
        return idx > 0
    }

    /// `true` when there is a next video available.
    func hasNext() -> Bool {
        guard let idx = currentIndex else { return !videos.isEmpty }
        return idx + 1 < videos.count
    }

    /// Bookmark of the previous video, or `nil` when at the beginning.
    func previousBookmark() -> Bookmark? {
        guard let idx = currentIndex, idx > 0 else { return nil }
        return Bookmark(video: videos[idx - 1])
    }

    /// Bookmark of the next video, or `nil` when at the end.
    func nextBookmark() -> Bookmark? {
        guard let idx = currentIndex else {
            // No current video selected – start from the first if exists.
            return videos.first.map { Bookmark(video: $0) }
        }
        let nextIdx = idx + 1
        guard nextIdx < videos.count else { return nil }
        return Bookmark(video: videos[nextIdx])
    }

    /// Advances the bookmark to the previous video when possible.
    mutating func moveToPrev() {
        if let b = previousBookmark() { bookmark = b }
    }

    /// Advances the bookmark to the next video when possible.
    mutating func moveToNext() {
        if let b = nextBookmark() { bookmark = b }
    }
}
