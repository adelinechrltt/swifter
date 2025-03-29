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

    var body: some Scene {
        WindowGroup {
//            EditSessionView()
//                .environmentObject(eventStoreManager)
            OnboardTimeOnFeet()
        }
        .modelContainer(for: [PreferencesModel.self, GoalModel.self])
    }
}
