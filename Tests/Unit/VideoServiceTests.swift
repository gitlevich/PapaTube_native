import Foundation
import Testing
@testable import PapaTube

@Suite("VideoService Integration")
struct VideoServiceIntegrationTests {
    
    // MARK: - Helpers
    
    /// Returns a configured `VideoService` or skips the test when no API key is available.
    private func makeService() throws -> VideoService {
        let key = ProcessInfo.processInfo.environment["YOUTUBE_API_KEY"] ?? ""
        try #require(!key.isEmpty, "`YOUTUBE_API_KEY` env var not configured – skipping live YouTube integration test.")
        return VideoService(apiKey: key)
    }
    
    /// Very loose heuristic for detecting Russian text – looks for at least one Cyrillic character.
    private func containsRussian(_ text: String) -> Bool {
        text.range(of: "[А-Яа-я]", options: .regularExpression) != nil
    }
    
    // MARK: - Tests
    
    @Test("Finds ten Russian movies from the 1970s")
    func findsTenRussianMoviesFrom1970s() async throws {
        let service = try makeService()
        
        // Build a spec that asks for 10 embeddable movies in Russian from the 1970s.
        let spec = PlaylistSpec(
            keywords: ["фильм", "1970"],
            maxResults: 10,
            language: "ru"
        )
        
        let videos = try await service.findMatching(spec)
        
        // Expect exactly 10 videos.
        #expect(videos.count == 10, "Expected 10 videos, received \(videos.count)")
        
        // Expect each video title to include Cyrillic characters (simple Russian check).
        for video in videos {
            #expect(containsRussian(video.title), "Video title (\(video.title)) does not appear to be in Russian")
        }
        
        // If the `Video` model exposes `publishedAt`, verify descending order.
        // Verify videos are sorted by publishedAt in descending order
        if let firstVideo = videos.first {
            await MainActor.run {
                var previous = firstVideo.publishedAt
                for video in videos.dropFirst() {
                    let current = video.publishedAt
                    #expect(previous >= current, "Videos are not sorted by publishedAt descending")
                    previous = current
                }
            }
        }
    }
}

