import Foundation
import Observation

@Observable
final class PlayerModel {
    // Playback state (stubbed)
    var isPlaying: Bool = false
    /// 0...1 fractional progress through the current video.
    var progress: Double = 0.0
    /// Dummy current video – replace later with real model.
    var video: Video? = nil

    // MARK: - User intents (no real side-effects yet)
    func togglePlayPause() {
        isPlaying.toggle()
    }

    func next() {
        // placeholder – plug playlist logic later
    }

    func previous() {
        // placeholder
    }
} 