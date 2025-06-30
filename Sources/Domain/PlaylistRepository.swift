//
//  PlaylistRepository.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/30/25.
//

// Domain
protocol PlaylistRepository {
    func load(spec: PlaylistSpec) async throws -> Playlist   // read
    func save(_ playlist: Playlist) async throws             // write
}
