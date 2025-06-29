//
//  YouTubeService.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import Foundation

actor VideoService {
    private let apiKey: String
    private let session: URLSession = .shared

    // Shared ISO-8601 date formatter for parsing YouTube timestamps.
    private static let iso8601 = ISO8601DateFormatter()

    init(apiKey: String = ProcessInfo.processInfo.environment["YOUTUBE_API_KEY"] ?? "") {
        self.apiKey = apiKey
    }

    func findMatching(_ spec: PlaylistSpec) async throws -> [Video] {
        // Validate that we have an API key to talk to YouTube.
        guard !apiKey.isEmpty else {
            throw URLError(.userAuthenticationRequired, userInfo: [NSLocalizedDescriptionKey: "Missing YouTube API key. Set it in the YOUTUBE_API_KEY environment variable or pass it to VideoService's init(apiKey:)." ])
        }

        // Build the search request first.
        let query = spec.keywords.joined(separator: "+")
        var searchComponents = URLComponents(string: "https://www.googleapis.com/youtube/v3/search")!
        searchComponents.queryItems = [
            .init(name: "part", value: "snippet"),
            .init(name: "type", value: "video"),
            .init(name: "maxResults", value: String(min(spec.maxResults, 50))), // API caps at 50 per request.
            .init(name: "q", value: query),
            .init(name: "key", value: apiKey)
        ]
        if let language = spec.language {
            searchComponents.queryItems?.append(.init(name: "relevanceLanguage", value: language))
        }

        let (searchData, searchResponse) = try await session.data(from: searchComponents.url!)
        guard (searchResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let searchPayload = try JSONDecoder().decode(SearchResponse.self, from: searchData)
        let ids = searchPayload.items.compactMap { $0.id.videoId }.filter { !$0.isEmpty }
        guard !ids.isEmpty else { return [] }

        // Fetch full details for the found IDs in one batch.
        var videosComponents = URLComponents(string: "https://www.googleapis.com/youtube/v3/videos")!
        videosComponents.queryItems = [
            .init(name: "part", value: "snippet,contentDetails"),
            .init(name: "id", value: ids.joined(separator: ",")),
            .init(name: "key", value: apiKey)
        ]

        let (videosData, videosResponse) = try await session.data(from: videosComponents.url!)
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
