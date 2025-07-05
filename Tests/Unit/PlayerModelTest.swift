import Foundation
import Testing

@testable import PapaTube

@Suite("PlayerModel")
struct PlayerModelTests {

    // MARK: - Tests

    @Test("togglePlayPause flips isPlaying")
    func togglePlayPauseFlips() throws {
        let model = PlayerModel(playlist: Playlist.playlistOf1)
        #expect(model.isPlaying == false)
        model.togglePlayPause()
        #expect(model.isPlaying == true)
        model.togglePlayPause()
        #expect(model.isPlaying == false)
    }

    @Test("next advances bookmark and resets isPlaying")
    func nextAdvancesAndResets() throws {
        let model = PlayerModel(playlist: Playlist.playlistOf3)
        #expect(model.playlist.currentVideo == Video.v1, "precondition")

        model.togglePlayPause() // set to playing
        #expect(model.isPlaying == true)

        // Act
        model.next()

        // Assert – moved to the second video & paused
        #expect(model.playlist.currentVideo == Video.v2)
        #expect(model.isPlaying == false)
        #expect(model.hasPrev == true)
        #expect(model.hasNext == true)
    }

    @Test("previous returns to prior video and resets isPlaying")
    func previousGoesBackAndResets() throws {
        var playlist = Playlist.playlistOf3
        playlist.moveToNext() // begin on second video
        let model = PlayerModel(playlist: playlist)

        model.togglePlayPause()
        #expect(model.isPlaying == true)

        // Act
        model.previous()

        // Assert – back to the first video & paused
        #expect(model.playlist.currentVideo.youtubeId == "1")
        #expect(model.isPlaying == false)
    }

//    @Test("progress getter and setter are symmetrical and clamped")
//    func progressGetterSetter() throws {
//        let duration = Duration.seconds(60)
//        // A 60-second video initially at 15-second mark (50 %).
//        let video = Video.v1
//        #expect(video.duration == duration, "precondition")
//        
//        let playlist = Playlist.stub(with: [video])
//        let model = PlayerModel(playlist: playlist)
//        
//        #expect(model.playlist.currentVideoStart == 0, "precondition")
//        
//        model.progress = 0.25
//        #expect(model.playlist.currentVideoStart == duration/4, "precondition")
//
//        #expect(abs(model.progress - 0.25) < 0.0001)
//
//        // Setter – move to the midpoint.
//        model.progress = 0.5
//        #expect(model.playlist.currentVideoStart == 100)
//
//        // Clamp below 0 → 0 seconds.
//        model.progress = -1
//        #expect(model.playlist.currentVideoStart == 0)
//
//        // Clamp above 1 → full duration.
//        model.progress = 2
//        #expect(model.playlist.currentVideoStart == 200)
//    }
}

