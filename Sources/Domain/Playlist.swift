//
//  Playlist.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import Foundation

struct Playlist: Sendable {
    let id: UUID
    let name: String
    let videos: [Video]
    let spec: PlaylistSpec

    static func make(
        name: String,
        videos: [Video],
        spec: PlaylistSpec
    ) -> Playlist {
        .init(id: UUID(), name: name, videos: videos, spec: spec)
    }
}
