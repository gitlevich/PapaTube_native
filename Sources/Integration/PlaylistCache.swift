//
//  PlaylistCache.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/30/25.
//

import CryptoKit
import Foundation
import Observation 
import SwiftData

// Stable key for caching
extension PlaylistSpec {
    fileprivate var cacheKey: String {
        let data = try! JSONEncoder().encode(self)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

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
        id = playlist.spec.cacheKey
        title = playlist.name
        videos = playlist.videos  // ← value copy
        spec = playlist.spec
    }

    func toDomain() -> Playlist {
        Playlist(
            id: UUID(uuidString: id) ?? UUID(),
            name: title,
            videos: videos,
            spec: spec
        )
    }
}

// ---------- thin cache adapter ----------
@MainActor
final class PlaylistCache {
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

    /// Persist latest metadata for future hits.
    func persist(_ playlist: Playlist) async throws {
        // replace old record (unique id ensures upsert)
        ctx.insert(CachedPlaylist(from: playlist))
        try ctx.save()
    }
}
