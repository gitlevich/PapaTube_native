import OSLog
import Foundation

/// Centralised `Logger` definitions for unified OS logging.
/// Use the relevant category when emitting logs.
enum Log {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "PapaTube"

    static let appLifecycle   = Logger(subsystem: subsystem, category: "app")
    static let playlist       = Logger(subsystem: subsystem, category: "playlist")
    static let videoService   = Logger(subsystem: subsystem, category: "video-service")
    static let persistence    = Logger(subsystem: subsystem, category: "persistence")
} 