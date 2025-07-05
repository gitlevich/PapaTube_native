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
            Double(playlist.currentVideo.progressAt(second: playlist.currentVideoStart))
        }
        set {
            playlist.currentVideoStart = playlist.currentVideo.secondsFromStart(at: newValue)
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

    private func updateDerivedState() {
        // Reset playing state if there is no real video.
        if currentVideo.isNone { isPlaying = false }
    }
}

private extension Double {
}
