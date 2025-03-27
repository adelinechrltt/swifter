//
//  PreferencesView.swift
//  Swifter
//
//  Created by Teuku Fazariz Basya on 27/03/25.
//

import SwiftUI
import SwiftData

struct PreferencesView: View {
    // Access the model container via environment
    @Environment(\.modelContext) private var modelContext
    
    // Query to fetch all PreferencesModel instances
    @Query private var preferences: [PreferencesModel]
    
    // State for UI controls
    @State private var selectedTimeOfDay: TimeOfDay = .morning
    @State private var selectedDayOfWeek: DayOfWeek = .monday
    @State private var preJogDuration: Int = 15
    @State private var postJogDuration: Int = 10
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Create New Preferences") {
                    Picker("Time of Day", selection: $selectedTimeOfDay) {
                        ForEach(TimeOfDay.allCases) { time in
                            Text(time.rawValue).tag(time)
                        }
                    }
                    
                    Picker("Day of Week", selection: $selectedDayOfWeek) {
                        ForEach(DayOfWeek.allCases) { day in
                            Text(day.name).tag(day)
                        }
                    }
                    
                    Stepper("Pre-jog duration: \(preJogDuration) min", value: $preJogDuration, in: 5...60, step: 5)
                    Stepper("Post-jog duration: \(postJogDuration) min", value: $postJogDuration, in: 5...60, step: 5)
                    
                    Button("Save Preferences") {
                        savePreferences()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
                
                Section("Saved Preferences") {
                    if preferences.isEmpty {
                        Text("No preferences saved yet")
                            .italic()
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(preferences) { pref in
                            VStack(alignment: .leading) {
                                Text("Times: \(pref.preferredTimesOfDay.map { $0.rawValue }.joined(separator: ", "))")
                                Text("Days: \(pref.preferredDaysOfWeek.map { $0.name }.joined(separator: ", "))")
                                Text("Pre-jog: \(pref.preJogDuration) min, Post-jog: \(pref.postJogDuration) min")
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deletePreferences)
                    }
                }
            }
            .navigationTitle("Preferences")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private func savePreferences() {
        // Create a new preferences model and save it
        let newPreferences = PreferencesModel(
            timeOfDay: [selectedTimeOfDay],
            dayOfWeek: [selectedDayOfWeek],
            preJogDuration: preJogDuration,
            postJogDuration: postJogDuration
        )
        
        modelContext.insert(newPreferences)
        
        // Try to save changes
        do {
            try modelContext.save()
        } catch {
            print("Failed to save preferences: \(error)")
        }
    }
    
    private func deletePreferences(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(preferences[index])
        }
        
        // Try to save changes
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete preferences: \(error)")
        }
    }
}

#Preview {
    PreferencesView()
        .modelContainer(for: PreferencesModel.self, inMemory: true)
}
