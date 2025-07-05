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
    let spec: PlaylistSpec

    fileprivate var entries: [PlaylistEntry]
    private var currentIndex: Int? = nil
    
    var videos: [Video] {
        entries.map { $0.video }
    }

    init(
        id: String,
        name: String,
        videos: [Video],
        spec: PlaylistSpec,
    ) {
        self.id = id
        self.name = name
        self.entries = videos.enumerated().map { idx, v in PlaylistEntry(video: v, index: idx) }
        self.spec = spec
        self.currentIndex = videos.isEmpty ? nil : 0
    }

    /// Seconds offset where playback should start for the current video.
    var currentVideoStart: Int {
        get {
            currentEntry?.startAt ?? 0
        }
        set {
            guard let idx = currentIndex else { return }
            entries[idx].startAt = newValue
        }
    }
    
    var size: Int {
        entries.count
    }
    
    private var currentEntry: PlaylistEntry? {
        currentIndex.flatMap { entries[$0] }
    }
    
    var currentVideo: Video {
        guard let idx = currentIndex else { return .none }
        return entries[idx].video
    }
    
    /// `true` when there is a previous video available.
    func hasPrev() -> Bool {
        previous() != nil
    }

    /// `true` when there is a next video available.
    func hasNext() -> Bool {
        next() != nil
    }

    /// Previous video, or `nil` when at the beginning.
    func previous() -> Video? {
        guard let idx = currentIndex, idx > 0 else { return nil }
        return entries[idx - 1].video
    }

    /// Next video, or `nil` when at the end.
    func next() -> Video? {
        var result: Video? = nil

        if let idx = currentIndex {
            let nextIdx = idx + 1
            if nextIdx < entries.count {
                result = entries[nextIdx].video
            }
        } else {
            // No current video selected – start from the first if one exists.
            result = entries.first?.video
        }

        return result
    }

    /// Advances to the previous video when possible.
    mutating func moveToPrev() {
        guard hasPrev(), let idx = currentIndex else { return }
        currentIndex = idx - 1
    }

    /// Advances to the next video when possible.
    mutating func moveToNext() {
        guard hasNext() else { return }
        if let idx = currentIndex {
            currentIndex = idx + 1
        } else {
            currentIndex = 0 // start at first video
        }
    }
    
    /// Null object – represents an empty playlist with default spec.
    static let none = Playlist(id: "", name: "", videos: [], spec: .reasonableDefault)
}


private struct PlaylistEntry: Sendable, Codable, Equatable, Hashable {
    let video: Video
    let index: Int
    var startAt: Int = 0
    
    init(video: Video, index: Int) {
        self.video = video
        self.index = index
    }
    
    mutating func setStartAt(_ secondsIntoVideo: Int) {
        self.startAt = secondsIntoVideo
    }
}

