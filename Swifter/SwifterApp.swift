//
//  SwifterApp.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 24/03/25.
//

import SwiftUI

@main
struct SwifterApp: App {
    
    @StateObject private var eventStoreManager = EventStoreManager()
    @StateObject private var watchConnector = WatchConnector()
    
    @Environment(\.modelContext) private var modelContext

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(eventStoreManager)
                .environmentObject(watchConnector)
                .environmentObject(JoggingSessionManager(modelContext: modelContext))
        }
        .modelContainer(for: [PreferencesModel.self, GoalModel.self, SessionModel.self])
    }
}

