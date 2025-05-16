//
//  WatchSwifterApp.swift
//  WatchSwifter Watch App
//
//  Created by Adeline Charlotte Augustinne on 15/05/25.
//

import SwiftUI

@main
struct WatchSwifter_Watch_AppApp: App {
    
    @StateObject private var watchToiOSConnector = WatchToiOSConnector()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(watchToiOSConnector)
        }
    }
}
