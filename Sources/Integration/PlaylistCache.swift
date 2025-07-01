//
//  PlaylistCache.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/30/25.
//

import Foundation
import Observation
import SwiftData

// ---------- SwiftData entity ----------
@Model
final class CachedPlaylist {

    // ------------ columns stored in the row -----------------------
    @Attribute(.unique) var id: String  // stable cache key
    var title: String
    var videos: [Video]
    var spec: PlaylistSpec
    var updatedAt = Date()  // staleness / sync check

    // MARK: Init / mapping
    init(from playlist: Playlist) {
        let key = playlist.spec.cacheKey
        id = key
        title = playlist.name
        videos = playlist.videos
        spec = playlist.spec
    }

    func toDomain() -> Playlist {
        spec.asPlaylist(with: videos)
    }
}

protocol PlaylistCaching {
    func lookup(_ spec: PlaylistSpec) async throws -> Playlist?
    func persist(_ playlist: Playlist) async throws
}

// ---------- thin cache adapter ----------
@MainActor
final class PlaylistCache: PlaylistCaching {
    private let ctx: ModelContext

    init(ctx: ModelContext) {
        self.ctx = ctx
    }

    /// Return cached or fetch-and-cache.
    func lookup(_ spec: PlaylistSpec) async throws -> Playlist? {
        // 1. hit SwiftData
        let desc = FetchDescriptor<CachedPlaylist>(
            predicate: #Predicate { $0.id == spec.cacheKey }
        )
        if let cached = try ctx.fetch(desc).first {
            return cached.toDomain()
        }
        return nil
    }

    /// Persist latest metadata for future hits (up‑sert by spec key).
    func persist(_ playlist: Playlist) async throws {
        let key = playlist.spec.cacheKey
        let desc = FetchDescriptor<CachedPlaylist>(
            predicate: #Predicate { $0.id == key }
        )

        if let existing = try ctx.fetch(desc).first {
            // overwrite mutable fields
            existing.title     = playlist.name
            existing.videos    = playlist.videos
            existing.spec      = playlist.spec
            existing.updatedAt = .now
        } else {
            ctx.insert(CachedPlaylist(from: playlist))
        }

        try ctx.save()
    }
}
