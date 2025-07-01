//
//  Bookmark.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 7/1/25.
//


import Foundation

struct Bookmark: Sendable, Codable, Equatable, Hashable {
        let video: Video
        let seconds: Double   // whole-second precision

        /// Null object – represents no selection / offset 0.
        static let none = Bookmark(video: .none, seconds: 0)
    }
