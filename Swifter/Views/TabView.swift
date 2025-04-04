////
////  ContentView.swift
////  Swifter
////
////  Created by Adeline Charlotte Augustinne on 24/03/25.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        TabView {
//            HomeView()
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
//            
//            PreferencesView()
//                .tabItem {
//                    Label("Preferences", systemImage: "gear")
//                }
//
//            ProfileView()
//                .tabItem {
//                    Label("Profile", systemImage: "person")
//                }
//
//            SettingsView()
//                .tabItem {
//                    Label("Settings", systemImage: "gearshape")
//                }
//        }
//    }
//}
//
//struct HomeView: View {
//    var body: some View {
//        NavigationStack {
//            Text("🏠 Home Screen")
//                .font(.largeTitle)
//                .toolbar {
//                    ToolbarItem(placement: .principal) {
//                        HStack {
//                            Text("Hot Topics")
//                                .font(.largeTitle)
//                            Spacer()
//                            Image(systemName: "star.fill")
//                                .foregroundStyle(.orange)
//                        }.padding(20)
//                    }
//                }
//        }
//    }
//}
//    
//    struct ProfileView: View {
//        var body: some View {
//            Text("👤 Profile Screen")
//                .font(.largeTitle)
//        }
//    }
//    
//    struct SettingsView: View {
//        var body: some View {
//            Text("⚙️ Settings Screen")
//                .font(.largeTitle)
//        }
//    }
//    
//    #Preview {
//        ContentView()
//    }
