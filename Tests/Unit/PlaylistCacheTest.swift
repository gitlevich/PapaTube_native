//
//  PapaTubeTests.swift
//  PapaTubeTests
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import Testing
@testable import PapaTube
import SwiftData
import Foundation

// MARK: - Test helpers

/// Returns an in‑memory ModelContext configured for CachedPlaylist.
private func makeTestContext() -> ModelContext {
    let container = try! ModelContainer(
        for: CachedPlaylist.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    return ModelContext(container)
}

/// Convenience helper to build a `Playlist` from spec + videos.
private func makePlaylist(_ spec: PlaylistSpec, _ videos: [Video]) -> Playlist {
    Playlist(id: spec.cacheKey, name: spec.keywords.joined(separator: " "),
             videos: videos,
             spec: spec)
}

@Suite("PlaylistCache")
struct PlaylistCacheTest {

    /// Cache miss should return `nil`.
    @Test
    func lookup_empty_returnsNil() async throws {
        let cache = await PlaylistCache(ctx: makeTestContext())               // adjust ctor if needed
        let spec  = PlaylistSpec.keywords(["a"])

        #expect(try await cache.lookup(spec) == nil)
    }

    /// Persist-then-lookup round-trip.
    @Test
    func persist_thenLookup_returnsSame() async throws {
        let cache  = await PlaylistCache(ctx: makeTestContext())
        let spec   = PlaylistSpec.keywords(["swift"])
        let videos = [Video.stub(id: "1")]
        let pl     = makePlaylist(spec, videos)

        try await cache.persist(pl)
        #expect(try await cache.lookup(spec) == pl)
    }

    /// Persisting twice with the same spec overwrites previous entry.
    @Test
    func persist_overwritesExisting() async throws {
        let cache   = await PlaylistCache(ctx: makeTestContext())
        let spec    = PlaylistSpec.keywords(["x"])
        let first   = makePlaylist(spec, [Video.stub(id: "1")])
        let updated = makePlaylist(spec, [Video.stub(id: "2")])

        try await cache.persist(first)
        try await cache.persist(updated)

        print(spec)
        print(first, updated)
        #expect(try await cache.lookup(spec) == updated)
    }

    /// Multiple different specs are kept independently.
    @Test
    func persists_multipleSpecs_independently() async throws {
        let cache  = await PlaylistCache(ctx: makeTestContext())
        let specA  = PlaylistSpec.keywords(["a"])
        let specB  = PlaylistSpec.keywords(["b"])

        try await cache.persist(makePlaylist(specA, [Video.stub(id: "1")]))
        try await cache.persist(makePlaylist(specB, [Video.stub(id: "2")]))

        #expect(try await cache.lookup(specA)?.spec == specA)
        #expect(try await cache.lookup(specB)?.spec == specB)
    }

}
