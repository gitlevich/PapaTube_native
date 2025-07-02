import SwiftUI
import Observation

struct PlayerView: View {
    /// Binding to a shared `PlayerModel` so that parent views can own the source of truth.
    @Bindable var model: PlayerModel
    @State private var isDimmed = false

    private let controlFadeDelay: TimeInterval = 30

    var body: some View {
        ZStack {
            // Video placeholder (replace with WKWebView later).
            Color.black
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Scrub bar (stubbed to 0…1).
                Slider(value: $model.progress)
                    .tint(.white)
                    .padding(.horizontal)

                HStack(spacing: 60) {
                    controlButton(systemName: "backward.fill") { model.previous() }
                    controlButton(systemName: model.isPlaying ? "pause.fill" : "play.fill") {
                        model.togglePlayPause()
                    }
                    controlButton(systemName: "forward.fill") { model.next() }
                }
                .padding(.top, 8)   // closer to the scrub bar
                .padding(.bottom, 24) // keep distance from bottom edge
            }
            .opacity(isDimmed ? 0.3 : 1)
            .onAppear(perform: scheduleFadeOut)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation { restoreBrightness() }
        }
    }

    // MARK: - Helpers
    private func controlButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 56))
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }

    private func restoreBrightness() {
        isDimmed = false
        scheduleFadeOut()
    }

    private func scheduleFadeOut() {
        DispatchQueue.main.asyncAfter(deadline: .now() + controlFadeDelay) {
            withAnimation { isDimmed = true }
        }
    }
}

#Preview {
    PlayerView(model: PlayerModel())
} 
