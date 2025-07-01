//
//  AppConfig.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import Foundation

public struct AppConfig {
    public enum Error: Swift.Error {
        case missingKey
    }

    public let youtubeApiKey: String

    /// Reads the API key from the app's Info.plist (key: `YouTubeAPIKey`).
    /// Fallback: environment variable `YOUTUBE_DATA_API_KEY` – convenient for CLI / CI.
    public init(bundle: Bundle? = .main,
                environment: [String: String] = ProcessInfo.processInfo.environment) throws {

        // 1. Prefer explicit environment variable (handy for tests / CI).
        if let key = environment[EnvKey.youtube.rawValue], !key.isEmpty {
            youtubeApiKey = key
            return
        }

        // 2. Fallback to bundle-embedded value.
        if let bundle,
           let key = bundle.infoDictionary?["YouTubeAPIKey"] as? String,
           !key.isEmpty {
            youtubeApiKey = key
            return
        }

        throw Error.missingKey
    }
}

public enum EnvKey: String {
    case youtube = "YOUTUBE_DATA_API_KEY"
}

extension Dictionary where Key == String {
    subscript(_ k: EnvKey) -> Value? { self[k.rawValue] }
}

