//
//  AppConfigTest.swift
//  PapaTubeTests

import Testing
import Foundation

@testable import PapaTube

@Suite("AppConfig")
struct AppConfigTests {
    
    @Test("throws when neither env nor bundle provides the key")
    func envEmpty() throws {
        try #require(throws: AppConfig.Error.self) {
            _ = try AppConfig(bundle: nil, environment: [:])
        }
    }
    
    @Test("throws if bundle lacks key and env variable is different")
    func keyMissing() throws {
        let stubEnv = ["SOME_OTHER_KEY": "foo"]
        try #require(throws: AppConfig.Error.self) {
            _ = try AppConfig(bundle: nil, environment: stubEnv)
        }
    }
    
    @Test("succeeds when YOUTUBE_DATA_API_KEY is present")
    func keyPresent() throws {
        let stubEnv = ["YOUTUBE_DATA_API_KEY": "abc123"]
        let config = try AppConfig(bundle: nil, environment: stubEnv)
        #expect(config.youtubeApiKey == "abc123")
    }
}
