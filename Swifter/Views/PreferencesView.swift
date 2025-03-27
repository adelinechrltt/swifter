//
//  PreferencesView.swift
//  Swifter
//
//  Created by Teuku Fazariz Basya on 27/03/25.
//

import SwiftUI
import SwiftData

struct PreferencesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [PreferencesModel]
    
    // Form state
    @State private var selectedTimesOfDay: Set<TimeOfDay> = []
    @State private var selectedDaysOfWeek: Set<DayOfWeek> = []
    @State private var preJogDuration: Int = 10
    @State private var postJogDuration: Int = 5
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Pre and Post Jog Duration") {
                    Stepper("Pre-jog Duration: \(preJogDuration) minutes", value: $preJogDuration, in: 0...60)
                    Stepper("Post-jog Duration: \(postJogDuration) minutes", value: $postJogDuration, in: 0...60)
                }
                
                Section("Preferred Times of Day") {
                    ForEach(TimeOfDay.allCases) { timeOfDay in
                        Button(action: {
                            toggleTimeOfDay(timeOfDay)
                        }) {
                            HStack {
                                Text(timeOfDay.rawValue)
                                Spacer()
                                if selectedTimesOfDay.contains(timeOfDay) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
                
                Section("Preferred Days of Week") {
                    ForEach(DayOfWeek.allCases) { day in
                        Button(action: {
                            toggleDayOfWeek(day)
                        }) {
                            HStack {
                                Text(day.name)
                                Spacer()
                                if selectedDaysOfWeek.contains(day) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
                
                Button("Save Preferences") {
                    savePreferences()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Jogging Preferences")
            .onAppear {
                loadExistingPreferences()
            }
        }
    }
    
    private func toggleTimeOfDay(_ timeOfDay: TimeOfDay) {
        if selectedTimesOfDay.contains(timeOfDay) {
            selectedTimesOfDay.remove(timeOfDay)
        } else {
            selectedTimesOfDay.insert(timeOfDay)
        }
    }
    
    private func toggleDayOfWeek(_ day: DayOfWeek) {
        if selectedDaysOfWeek.contains(day) {
            selectedDaysOfWeek.remove(day)
        } else {
            selectedDaysOfWeek.insert(day)
        }
    }
    
    private func savePreferences() {
        // Delete previous preferences if they exist
        for preference in preferences {
            modelContext.delete(preference)
        }
        
        // Create and save new preferences
        let newPreferences = PreferencesModel(
            timeOfDay: Array(selectedTimesOfDay),
            dayOfWeek: Array(selectedDaysOfWeek),
            preJogDuration: preJogDuration,
            postJogDuration: postJogDuration
        )
        
        modelContext.insert(newPreferences)
        
        // Save the context
        do {
            try modelContext.save()
        } catch {
            print("Error saving preferences: \(error)")
        }
    }
    
    private func loadExistingPreferences() {
        if let existingPreferences = preferences.first {
            selectedTimesOfDay = Set(existingPreferences.preferredTimesOfDay)
            selectedDaysOfWeek = Set(existingPreferences.preferredDaysOfWeek)
            preJogDuration = existingPreferences.preJogDuration
            postJogDuration = existingPreferences.postJogDuration
        }
    }
}

#Preview {
    PreferencesView()
        .modelContainer(for: PreferencesModel.self, inMemory: true)
}
