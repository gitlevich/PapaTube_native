//
//  YouTubeService.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import Foundation

protocol VideoServicing {
    func findMatching(_ spec: PlaylistSpec) async throws -> [Video]
}

actor VideoService: VideoServicing {
    private let apiKey: String
    private let session: URLSession = .shared

    // Shared ISO-8601 date formatter for parsing YouTube timestamps.
    private static let iso8601 = ISO8601DateFormatter()

    init(appConfig: AppConfig) {
        self.apiKey = appConfig.youtubeApiKey
    }

    func findMatching(_ spec: PlaylistSpec) async throws -> [Video] {
        // Build the search URL in a type‑safe way so we never end up with an unsupported URL.
        var searchComponents = URLComponents()
        searchComponents.scheme = "https"
        searchComponents.host = "youtube.googleapis.com"
        searchComponents.path = "/youtube/v3/search"
        searchComponents.queryItems = [
            .init(name: "part", value: "snippet"),
            .init(name: "type", value: "video"),
            .init(name: "maxResults", value: String(min(spec.maxResults, 50))), // API caps at 50 per request.
            .init(name: "q", value: spec.keywords.joined(separator: " ")),      // let URLComponents handle encoding
            .init(name: "key", value: apiKey)
        ]
        if let language = spec.language {
            searchComponents.queryItems?.append(.init(name: "relevanceLanguage", value: language))
        }
        guard let searchURL = searchComponents.url else {
            throw URLError(.badURL)
        }

        let (searchData, searchResponse) = try await session.data(from: searchURL)
        guard (searchResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let searchPayload = try JSONDecoder().decode(SearchResponse.self, from: searchData)
        let ids = searchPayload.items.compactMap { $0.id.videoId }.filter { !$0.isEmpty }
        guard !ids.isEmpty else { return [] }

        // Fetch full details for the found IDs in one batch.
        var videosComponents = URLComponents()
        videosComponents.scheme = "https"
        videosComponents.host = "youtube.googleapis.com"
        videosComponents.path = "/youtube/v3/videos"
        videosComponents.queryItems = [
            .init(name: "part", value: "snippet,contentDetails"),
            .init(name: "id", value: ids.joined(separator: ",")),
            .init(name: "key", value: apiKey)
        ]
        guard let videosURL = videosComponents.url else {
            throw URLError(.badURL)
        }

        let (videosData, videosResponse) = try await session.data(from: videosURL)
        guard (videosResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let videosPayload = try JSONDecoder().decode(VideosResponse.self, from: videosData)

        return videosPayload.items.map { item in
            let thumbnailURL = item.snippet.thumbnails.high?.url ??
                               item.snippet.thumbnails.medium?.url ??
                               item.snippet.thumbnails.default?.url ?? ""
            return Video(
                youtubeId: item.id,
                title: item.snippet.title,
                thumbnailUrl: thumbnailURL,
                duration: item.contentDetails.duration,
                url: "https://www.youtube.com/watch?v=\(item.id)",
                publishedAt: VideoService.iso8601.date(from: item.snippet.publishedAt) ?? .distantPast
            )
        }.sorted { $0.publishedAt > $1.publishedAt }
    }

    // MARK: - Private JSON models
    private struct SearchResponse: Decodable {
        struct SearchItem: Decodable {
            struct Identifier: Decodable {
                let videoId: String
            }
            let id: Identifier
        }
        let items: [SearchItem]
    }

    private struct VideosResponse: Decodable {
        struct VideosItem: Decodable {
            struct Snippet: Decodable {
                struct Thumbnail: Decodable { let url: String }
                struct Thumbnails: Decodable {
                    let `default`: Thumbnail?
                    let medium: Thumbnail?
                    let high: Thumbnail?
                }
                let title: String
                let thumbnails: Thumbnails
                let publishedAt: String
            }
            struct ContentDetails: Decodable { let duration: String }

            let id: String
            let snippet: Snippet
            let contentDetails: ContentDetails
        }
        let items: [VideosItem]
    }
}
