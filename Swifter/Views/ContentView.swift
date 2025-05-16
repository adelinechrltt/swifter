//
//  ContentView.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 24/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var watchConnector: WatchConnector

    @Environment(\.modelContext) private var modelContext
    private var goalManager: GoalManager {
        GoalManager(modelContext: modelContext)
    }
    private var preferencesManager: PreferencesManager {
        PreferencesManager(modelContext: modelContext)
    }
    
    @AppStorage("isNewUser") private var isNewUser: Bool = false
    
    var body: some View {
        
//        Group{
//            if(isNewUser) {
//                OnboardStart()
//            } else {
//                TabView {
//                    NavigationStack{
//                        UpcomingSession()
//                    }.tabItem {
//                        Label("Upcoming", systemImage: "house")
//                    }
//                    CalendarView()
//                        .tabItem {
//                            Label("Calendar", systemImage: "calendar")
//                        }
//                }
//            }
//        }.onAppear {
//                if let userJogDuration = preferencesManager.fetchPreferences()?.jogDuration,
//                   let userGoals = goalManager.fetchGoals() {
//                    isNewUser = false
//                    print(userJogDuration)
//                    print(userGoals)
//                } else {
//                    isNewUser = true
//                }
//            print(isNewUser)
//        }
        
        /// for troubleshooting
        VStack {
            Text("iOS App")
            Button("Send Data to Watch") {
                Task {
                    await testFullDataRoundtrip()
                }
            }
        }
    }
    
    // NEW FUNCTION for the full roundtrip test
        func testFullDataRoundtrip() async {
            watchConnector.setupModelContext(modelContext)
            
            print("iOS: --- Starting Full Data Roundtrip Test ---")

            // 1) Create and insert a new Session and Goal model
            let newSession = SessionModel(
                startTime: Date(),
                endTime: Date().addingTimeInterval(120 * 60), // 2 hours from now
                calendarEventID: "roundtrip_event_id_\(UUID().uuidString.prefix(5))",
                sessionType: .jogging
            )
            let newGoal = GoalModel(
                targetFrequency: 7,
                startDate: Date().addingTimeInterval(-7 * 24 * 3600), // 7 days ago
                endDate: Date().addingTimeInterval(7 * 24 * 3600) // 7 days from now
            )

            modelContext.insert(newSession)
            modelContext.insert(newGoal)

            do {
                try modelContext.save() // Ensure models get stable PersistentIdentifiers
                print("iOS: Successfully created and inserted new Session and Goal models.")
            } catch {
                print("iOS: ERROR: Failed to save new models: \(error.localizedDescription)")
                return
            }

            guard let sessionDTOToSend = sessionModelToDTO(model: newSession),
                  let goalDTOToSend = goalModelToDTO(model: newGoal) else { // Using corrected function name
                print("iOS: ERROR: Failed to convert SessionModel or GoalModel to DTO.")
                return
            }
            
            print("iOS: Original Session Model ID: \(newSession.persistentModelID) (DTO ID: \(sessionDTOToSend.id))")
            print("iOS: Original Goal Model ID: \(newGoal.persistentModelID) (DTO ID: \(goalDTOToSend.id))")


            watchConnector.sendUpdatedContext(session: sessionDTOToSend, goal: goalDTOToSend)
            print("iOS: Sent DTOs with original PersistentID strings to Watch app.")

        }
}

#Preview {
    ContentView()
}
