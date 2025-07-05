import Foundation
import Observation

@Observable
final class PlayerModel {
    // MARK: - Dependencies
    /// The playlist currently being played.
    var playlist: Playlist {
        didSet { updateDerivedState() }
    }

    // MARK: - UI-bound state
    private(set) var isPlaying: Bool = false

    /// 0…1 progress proxy for the scrub bar.
    var progress: Double {
        get {
            return Double(playlist.currentVideo.progressAt(second: playlist.currentVideoStart))
        }
        set {
            playlist.currentVideoStart = newValue.seconds(from: playlist.currentVideo.duration)
        }
    }

    // MARK: - Derived helpers
    var currentVideo: Video { playlist.currentVideo }
    var hasNext: Bool { playlist.hasNext() }
    var hasPrev: Bool { playlist.hasPrev() }

    // MARK: - Init
    init(playlist: Playlist = .none) {
        self.playlist = playlist
        updateDerivedState()
    }

    // MARK: - Intents
    func togglePlayPause() { isPlaying.toggle() }

    func next() {
        playlist.moveToNext()
        isPlaying = false
    }

    func previous() {
        playlist.moveToPrev()
        isPlaying = false
    }

    // TODO: review; i think this implementation is not useful
    // MARK: - Private
    private func updateDerivedState() {
        // Reset playing state if there is no real video.
        if currentVideo.isNone { isPlaying = false }
    }
}

// MARK: - Progress conversion helper
private extension Double {
    /// Converts a 0…1 progress value into seconds offset from the start.
    /// - Parameter total: total duration in seconds.
    /// - Returns: whole‑second offset from the start.
    /// - Precondition: `self` must be in 0…1 and `total` ≥ 0.
    func seconds(from total: Duration) -> Int {
        precondition((0...1).contains(self), "Progress must be between 0 and 1")
        return Int((self * Double(total.secondsInt)).rounded())
    }
}
