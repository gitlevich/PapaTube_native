//
//  PlaylistStoreTest.swift
//  PapaTubeTests
//
//  Created by Vladimir Gitlevich on 6/30/25.
//

import Testing

@testable import PapaTube

import Testing
import Foundation

@testable import PapaTube

@Suite("PlaylistStore")
struct PlaylistStoreTest {

    @Test("load fetches remotely then caches")
    func load_fetchesAndPersists() async throws {
        let spec   = PlaylistSpec.keywords(["swift"], maxResults: 10, language: nil)
        let videos = [Video.stub(id:"1"), .stub(id:"2")]
        let remote = MockVideoService(result: videos)
        let local  = MockPlaylistCache()
        let sut    = PlaylistStore(remote: remote, local: local)

        let playlist = try await sut.load(spec: spec)

        #expect(playlist.videos == videos)
        #expect(await remote.askedSpec == spec)
        #expect(await local.persisted?.spec == spec)
    }
}

final actor MockVideoService: VideoServicing {
    private(set) var askedSpec: PlaylistSpec?
    let result: [Video]

    init(result: [Video]) { self.result = result }

    func findMatching(_ spec: PlaylistSpec) async throws -> [Video] {
        askedSpec = spec
        return result
    }
}

final actor MockPlaylistCache: PlaylistCaching {
    private var stored: [PlaylistSpec: Playlist]
    private(set) var persisted: Playlist?

    init(preloaded: [PlaylistSpec: Playlist] = [:]) {
        self.stored = preloaded
    }

    func lookup(_ spec: PlaylistSpec) async throws -> Playlist? { stored[spec] }

    func persist(_ playlist: Playlist) async throws { persisted = playlist }
}
