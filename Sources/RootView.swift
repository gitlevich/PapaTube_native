import SwiftUI

/// Root view responsible for loading the initial playlist via the provided repository
/// and showing the appropriate screen when data is ready.
struct RootView: View {
    let store: PlaylistRepository
    @State private var playlist: Playlist? = nil
    @State private var error: Error? = nil

    var body: some View {
        Group {
            if let playlist {
                PlayerView(model: PlayerModel(playlist: playlist))
            } else if let error {
                VStack(spacing: 16) {
                    Text("Failed to load playlist")
                        .foregroundStyle(.secondary)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        load()
                    }
                }
                .padding()
            } else {
                ProgressView("Loading…")
            }
        }
        .task { load() }
    }

    private func load() {
        Task {
            do {
                let spec = PlaylistSpec.reasonableDefault
                let p = try await store.load(spec: spec)
                await MainActor.run { self.playlist = p }
            } catch {
                await MainActor.run { self.error = error }
            }
        }
    }
}

#Preview {
    struct StubStore: PlaylistRepository {
        func load(spec: PlaylistSpec) async throws -> Playlist { spec.asPlaylist(with: []) }
        func save(_ playlist: Playlist) async throws {}
    }
    return RootView(store: StubStore())
} 