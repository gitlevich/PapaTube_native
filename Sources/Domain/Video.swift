//
//  Video.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import Foundation

struct Video: Sendable {
    let youtubeId: String
    let title: String
    let thumbnailUrl: String
    let duration: String
    let url: String
    let publishedAt: Date
}
