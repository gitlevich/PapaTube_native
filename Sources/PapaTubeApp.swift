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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            PlayerView(model: PlayerModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
