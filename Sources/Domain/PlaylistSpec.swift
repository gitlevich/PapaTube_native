//
//  PlaylistSpec.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//
//  Specification for the playlist to retrieve from YouTube

import Foundation
import CryptoKit

/// Specification used for building / caching a playlist.
struct PlaylistSpec: Sendable, Codable, Hashable, Equatable {
    let keywords: [String]
    let maxResults: Int
    let language: String?
}

// MARK: – Derived helpers
extension PlaylistSpec {

    /// Stable SHA-256 digest of the spec – identical for semantically equal specs.
    var cacheKey: String {
        let encoder = JSONEncoder()
        if #available(macOS 13.0, *) {
            encoder.outputFormatting = [.sortedKeys]
        } else {
            encoder.outputFormatting = .sortedKeys
        }
        let data = try! encoder.encode(self)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    /// Construct a domain `Playlist` with a deterministic id.
    func asPlaylist(with videos: [Video]) -> Playlist {
        Playlist(id: cacheKey, name: keywords.joined(separator: " "), videos: videos, spec: self)
    }

    /// Convenience builder mirroring previous `keywords(_:)` helper used in tests.
    static func keywords(_ words: [String], maxResults: Int = 10, language: String? = "en") -> PlaylistSpec {
        .init(keywords: words, maxResults: maxResults, language: language)
    }
}
