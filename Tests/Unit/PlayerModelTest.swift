import Foundation
import Testing

@testable import PapaTube

@Suite("PlayerModel")
struct PlayerModelTests {

    // MARK: - Helpers
    /// Builds a `Video` instance with a customizable ISO-8601 duration string.
    private func makeVideo(id: String, duration: String = "PT120S") -> Video {
        Video(
            youtubeId: id,
            title: "stub",
            thumbnailUrl: "https://x/\(id)/thumb",
            duration: duration,
            url: "https://x/\(id)",
            publishedAt: .now,
            startAt: 0
        )
    }

    /// Convenience builder for a one-off playlist used inside the tests.
    private func makePlaylist(_ videos: [Video]) -> Playlist {
        Playlist(id: "pl", name: "test", videos: videos, spec: .reasonableDefault)
    }

    // MARK: - Tests

    @Test("togglePlayPause flips isPlaying")
    func togglePlayPauseFlips() throws {
        let model = PlayerModel(playlist: makePlaylist([makeVideo(id: "1")]))
        #expect(model.isPlaying == false)
        model.togglePlayPause()
        #expect(model.isPlaying == true)
        model.togglePlayPause()
        #expect(model.isPlaying == false)
    }

    @Test("next advances bookmark and resets isPlaying")
    func nextAdvancesAndResets() throws {
        let model = PlayerModel(playlist: makePlaylist([
            makeVideo(id: "1"),
            makeVideo(id: "2")
        ]))

        model.togglePlayPause() // set to playing
        #expect(model.isPlaying == true)

        // Act
        model.next()

        // Assert – moved to the second video & paused
        #expect(model.playlist.bookmark.video.youtubeId == "2")
        #expect(model.isPlaying == false)
        #expect(model.hasPrev == true)
        #expect(model.hasNext == false)
    }

    @Test("previous returns to prior video and resets isPlaying")
    func previousGoesBackAndResets() throws {
        var playlist = makePlaylist([makeVideo(id: "1"), makeVideo(id: "2")])
        playlist.moveToNext() // begin on second video
        let model = PlayerModel(playlist: playlist)

        model.togglePlayPause()
        #expect(model.isPlaying == true)

        // Act
        model.previous()

        // Assert – back to the first video & paused
        #expect(model.playlist.bookmark.video.youtubeId == "1")
        #expect(model.isPlaying == false)
    }

    @Test("progress getter and setter are symmetrical and clamped")
    func progressGetterSetter() throws {
        // A 200-second video initially at 50-second mark (25 %).
        var video = makeVideo(id: "1", duration: "PT200S")
        video.startAt = 50
        let model = PlayerModel(playlist: makePlaylist([video]))

        // Getter – expect ≈0.25 progress.
        #expect(abs(model.progress - 0.25) < 0.0001)

        // Setter – move to the midpoint.
        model.progress = 0.5
        #expect(model.playlist.bookmark.seconds == 100)

        // Clamp below 0 → 0 seconds.
        model.progress = -1
        #expect(model.playlist.bookmark.seconds == 0)

        // Clamp above 1 → full duration.
        model.progress = 2
        #expect(model.playlist.bookmark.seconds == 200)
    }
} 