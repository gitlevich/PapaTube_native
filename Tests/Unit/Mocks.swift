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
            duration:     "60",
            url:          "https://x/\(id)",      // if the property is `String`
            publishedAt:  .now,
        )
    }
}


