//
//  Mocks.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/30/25.
//

@testable import PapaTube
import Foundation


extension Video {
    /// Adjust labels / types to whatever `Video` really has.
    static func stub(id: String) -> Self {
        .init(
            youtubeId:    id,
            title:        "stub",
            thumbnailUrl: "https://x/\(id)/thumb",
            duration:     Duration.seconds(60),
            url:          "https://x/\(id)",      // if the property is `String`
            publishedAt:  .now,
        )
    }
    
    // Fixtures:
    static let v1 = Video.stub(id: "1")
    static let v2 = Video.stub(id: "2")
    static let v3 = Video.stub(id: "3")
}

extension Playlist {
    static func stub(with videos: [Video]) -> Playlist {
        let spec = PlaylistSpec.reasonableDefault
        return Playlist(
            id: spec.cacheKey,
            name: "test",
            videos: videos,
            spec: spec
        )
    }
    
    // Fixtures:
    static let empty = stub(with: [])
    static let playlistOf1 = stub(with: [.v1])
    static let playlistOf3 = stub(with: [.v1, .v2, .v3])
}


