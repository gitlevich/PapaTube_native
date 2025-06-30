//
//  AppConfig.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import DotEnv
import Foundation

public struct AppConfig {
    enum Error: Swift.Error {
        case missingKey
        case missingDotEnv
    }

    let youtubeApiKey: String

    init(environment: [String: String] = ProcessInfo.processInfo.environment) throws {
        guard let key = environment[.youtube] else {
            throw Error.missingKey
        }
        youtubeApiKey = key
    }
}


public enum EnvKey: String {
    case youtube = "YOUTUBE_DATA_API_KEY"
}

extension Dictionary where Key == String {
    subscript(_ k: EnvKey) -> Value? { self[k.rawValue] }
}

