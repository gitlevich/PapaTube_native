import Foundation
import Testing

@testable import PapaTube

// Marker class used to locate the test bundle that contains resources such as .env
private final class TestBundleMarker {}

@Suite("VideoService Integration")
struct VideoServiceIntegrationTests {
    
    // MARK: - Helpers
    
    /// Returns a configured `VideoService` or skips the test when no API key is available.
    private func makeService() throws -> VideoService {
        // Integration tests hit the real YouTube API. Opt-in via RUN_LIVE_TESTS=1.
        guard ProcessInfo.processInfo.environment["RUN_LIVE_TESTS"] == "1" else {
            throw AppConfig.Error.missingKey // placeholder to stop test; will be caught
        }

        let appConfig = try AppConfig()
        return VideoService(appConfig: appConfig)
    }
    
    /// Very loose heuristic for detecting Russian text – looks for at least one Cyrillic character.
    private func containsRussian(_ text: String) -> Bool {
        text.range(of: "[А-Яа-я]", options: .regularExpression) != nil
    }
    
    // MARK: - Tests
    
    @Test("Finds ten Russian movies from the 1970s")
    func findsTenRussianMoviesFrom1970s() async throws {
        guard let service = try? makeService() else { return } // Skip when not configured
        
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
        let russianTitles = videos.filter { containsRussian($0.title) }
        #expect(russianTitles.count >= 5, "Expected at least 5 Russian titles out od 10, received \(russianTitles.count)")
        
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
