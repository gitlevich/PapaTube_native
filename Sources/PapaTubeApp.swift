//
//  PapaTubeApp.swift
//  PapaTube
//
//  Created by Vladimir Gitlevich on 6/29/25.
//

import SwiftUI
import SwiftData

@main
struct PapaTubeApp: App {
    // Shared SwiftData container
    let sharedModelContainer: ModelContainer
    // Single instance of the playlist repository
    let playlistStore: PlaylistStore

    // MARK: - Init (composition root)
    init() {
        // 1. SwiftData setup
        let schema = Schema([Item.self, CachedPlaylist.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        // 2. Integration services
        let cache = PlaylistCache(ctx: sharedModelContainer.mainContext)
        let appConfig: AppConfig
        do {
            appConfig = try AppConfig()
        } catch {
            fatalError("Missing YouTube API key: \(error)")
        }
        let remote = VideoService(appConfig: appConfig)
        playlistStore = PlaylistStore(remote: remote, local: cache)
    }

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            RootView(store: playlistStore)
        }
        .modelContainer(sharedModelContainer)
    }
}
