//
//  AppConfigTest.swift
//  PapaTubeTests

import Testing

@testable import PapaTube

@Suite("AppConfig")
struct AppConfigTests {
    
    @Test("throws if env dictionary is empty")
    func envEmpty() throws {
        try #require(throws: AppConfig.Error.self) {
            _ = try AppConfig(environment: [:])
        }
    }
    
    @Test("throws if YOUTUBE_API_KEY is absent")
    func keyMissing() throws {
        let stubEnv = ["SOME_OTHER_KEY": "foo"]
        try #require(throws: AppConfig.Error.self) {
            _ = try AppConfig(environment: stubEnv)
        }
    }
    
    @Test("succeeds when YOUTUBE_API_KEY is present")
    func keyPresent() throws {
        let stubEnv = ["YOUTUBE_API_KEY": "abc123"]
        let config = try AppConfig(environment: stubEnv)
        #expect(config.youtubeApiKey == "abc123")
    }
}
