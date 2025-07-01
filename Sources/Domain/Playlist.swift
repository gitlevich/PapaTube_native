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
}
