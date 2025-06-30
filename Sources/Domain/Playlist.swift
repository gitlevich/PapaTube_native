//
//  Playlist.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

struct Playlist: Sendable {
    let name: String
    let videos: [Video]
    let spec: PlaylistSpec
}
