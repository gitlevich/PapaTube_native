import SwiftUI
import WebKit
import OSLog

#if canImport(UIKit)
// UIKit implementation for iOS / iPadOS.
/// A lightweight YouTube player wrapper using the IFrame API.
/// - Loads the given `videoId`.
/// - Plays / pauses on `isPlaying` binding.
/// - All user interaction is disabled so touches pass through to the parent.
struct YouTubeEmbedView: UIViewRepresentable {
    let videoId: String
    @Binding var isPlaying: Bool
    @Binding var positionSeconds: Int

    func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        cfg.allowsInlineMediaPlayback = true
        if #available(iOS 15.0, *) {
            cfg.mediaTypesRequiringUserActionForPlayback = []
        }
        let webView = WKWebView(frame: .zero, configuration: cfg)
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .black
        // Disable interaction so touches go to overlay controls.
        webView.isUserInteractionEnabled = false

        load(videoId: videoId, in: webView, startAt: positionSeconds)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // If video changed, load a new one.
        if context.coordinator.currentVideoId != videoId {
            load(videoId: videoId, in: webView, startAt: positionSeconds)
            context.coordinator.currentVideoId = videoId
        }

        // Seek if position changed
        if context.coordinator.lastReportedPosition != positionSeconds {
            let js = "if (typeof player !== 'undefined') { player.seekTo(\(positionSeconds), true); }"
            webView.evaluateJavaScript(js)
            context.coordinator.lastReportedPosition = positionSeconds
        }

        // Sync play / pause state, queuing play if the player is not ready yet.
        let js: String
        if isPlaying {
            js = "if (typeof player !== 'undefined' && player.playVideo) { player.playVideo(); } else { window.pendingPlay = true; }"
        } else {
            js = "if (typeof player !== 'undefined' && player.pauseVideo) { player.pauseVideo(); window.pendingPlay = false; } else { window.pendingPlay = false; }"
        }
        webView.evaluateJavaScript(js)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(currentVideoId: videoId, lastReportedPosition: positionSeconds)
    }

    // MARK: - Private helpers
    private func load(videoId: String, in webView: WKWebView, startAt: Int) {
        let html = Self.html(for: videoId, startAt: startAt)
        webView.loadHTMLString(html, baseURL: nil)
        Log.videoService.debug("Loaded YouTube video \(videoId, privacy: .public)")
    }

    private static func html(for id: String, startAt: Int) -> String {
        """
        <!doctype html>
        <html>
          <head>
            <meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0\">
            <style>body,html{margin:0;padding:0;background:#000;}</style>
            <script src=\"https://www.youtube.com/iframe_api\"></script>
            <script>
              var player;
              var pendingPlay = false; // will be set from Swift if play is requested before player is ready
              function onYouTubeIframeAPIReady() {
                player = new YT.Player('ytplayer', {
                  events: {
                    'onReady': function () {
                      if (pendingPlay) {
                        player.playVideo();
                        pendingPlay = false;
                      }
                    }
                  }
                });
              }
            </script>
          </head>
          <body>
            <iframe id=\"ytplayer\" type=\"text/html\" width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"https://www.youtube.com/embed/
        \(id)?enablejsapi=1&playsinline=1&controls=0&rel=0&start=\(startAt)\"></iframe>
          </body>
        </html>
        """
    }

    // Coordinator to keep mutable state between updates.
    class Coordinator {
        var currentVideoId: String
        var lastReportedPosition: Int
        init(currentVideoId: String, lastReportedPosition: Int) {
            self.currentVideoId = currentVideoId
            self.lastReportedPosition = lastReportedPosition
        }
    }
}
#else
// Placeholder for macOS build to satisfy compiler.
struct YouTubeEmbedView: View {
    var videoId: String
    @Binding var isPlaying: Bool
    @Binding var positionSeconds: Int

    var body: some View {
        Color.black // simple placeholder
    }
}
#endif 