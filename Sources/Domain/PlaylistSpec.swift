//
//  PlaylistSpec.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//
//  Specification for the playlist to retrieve from YouTube

import Foundation


struct PlaylistSpec: Sendable, Codable {
    let keywords: [String]
    let maxResults: Int
    let language: String?
}
