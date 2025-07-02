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
            guard durationSeconds > 0 else { return 0 }
            return playlist.bookmark.seconds.toDouble() / durationSeconds
        }
        set {
            playlist.bookmark.seconds = Int((max(0, min(1, newValue)) * durationSeconds).rounded())
        }
    }

    // MARK: - Derived helpers
    var currentVideo: Video { playlist.bookmark.video }
    var hasNext: Bool { playlist.hasNext() }
    var hasPrev: Bool { playlist.hasPrev() }

    private var durationSeconds: Double {
        ISO8601Duration.seconds(from: currentVideo.duration)
    }

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

    // MARK: - Private
    private func updateDerivedState() {
        // Reset playing state if there is no real video.
        if currentVideo.isNone { isPlaying = false }
    }
}


extension Int {
    /// Convenience conversion from `Int` to `Double`.
    func toDouble() -> Double {
        Double(self)
    }
}
