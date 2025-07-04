//
//  VideoStore.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

// Integration
final class PlaylistStore: PlaylistRepository {
    private let remote: VideoServicing
    private let local: PlaylistCaching

    init(remote: VideoServicing, local: PlaylistCaching) {
        self.remote = remote
        self.local = local
    }

    func load(spec: PlaylistSpec) async throws -> Playlist {
        if let cached = try await local.lookup(spec) { return cached }

        let videos = try await remote.findMatching(spec)  // network
        let playlist = spec.asPlaylist(with: videos)
        try await local.persist(playlist)  // SwiftData
        return playlist
    }

    func save(_ playlist: Playlist) async throws {
        try await local.persist(playlist)
    }
}
