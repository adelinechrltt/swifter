//
//  ContentView.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 24/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            UpcomingSession()
                .tabItem {
                    Label("Upcoming", systemImage: "house")
                }
        }
    }
}

#Preview {
    ContentView()
}
