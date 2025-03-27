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
    
    // State for UI controls - using sets for multiple selections
    @State private var selectedTimesOfDay: Set<TimeOfDay> = [.morning]
    @State private var selectedDaysOfWeek: Set<DayOfWeek> = [.monday]
    @State private var preJogDuration: Int = 15
    @State private var postJogDuration: Int = 10
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Create New Preferences") {
                    // Times of day section with toggles
                    Section("Select Times of Day") {
                        ForEach(TimeOfDay.allCases) { time in
                            Toggle(time.rawValue, isOn: Binding(
                                get: { selectedTimesOfDay.contains(time) },
                                set: { isOn in
                                    if isOn {
                                        selectedTimesOfDay.insert(time)
                                    } else {
                                        selectedTimesOfDay.remove(time)
                                    }
                                }
                            ))
                        }
                    }
                    
                    // Days of week section with toggles
                    Section("Select Days of Week") {
                        ForEach(DayOfWeek.allCases) { day in
                            Toggle(day.name, isOn: Binding(
                                get: { selectedDaysOfWeek.contains(day) },
                                set: { isOn in
                                    if isOn {
                                        selectedDaysOfWeek.insert(day)
                                    } else {
                                        selectedDaysOfWeek.remove(day)
                                    }
                                }
                            ))
                        }
                    }
                    
                    Section("Duration Settings") {
                        Stepper("Pre-jog duration: \(preJogDuration) min", value: $preJogDuration, in: 5...60, step: 5)
                        Stepper("Post-jog duration: \(postJogDuration) min", value: $postJogDuration, in: 5...60, step: 5)
                    }
                    
                    Button("Save Preferences") {
                        savePreferences()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .disabled(selectedTimesOfDay.isEmpty || selectedDaysOfWeek.isEmpty)
                }
                
                Section("Saved Preferences") {
                    if preferences.isEmpty {
                        Text("No preferences saved yet")
                            .italic()
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(preferences) { pref in
                            VStack(alignment: .leading, spacing: 4) {
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
        // Validate we have at least one selection for each category
        guard !selectedTimesOfDay.isEmpty, !selectedDaysOfWeek.isEmpty else {
            return
        }
        
        // Create a new preferences model with all selected options
        let newPreferences = PreferencesModel(
            timeOfDay: Array(selectedTimesOfDay),
            dayOfWeek: Array(selectedDaysOfWeek),
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
