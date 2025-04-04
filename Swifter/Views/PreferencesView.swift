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
    
    // Query to fetch preferences
    @Query private var preferences: [PreferencesModel]
    
    // State variables to track user changes
    @State private var selectedTimesOfDay: Set<TimeOfDay> = []
    @State private var selectedDaysOfWeek: Set<DayOfWeek> = []
    @State private var preJogDuration: Int = 15
    @State private var postJogDuration: Int = 10
    
    // Computed property to get the current preference
    private var currentPreference: PreferencesModel? {
        preferences.first
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Your Preferences") {
                    // Times of day section with toggles
                    Section("Preferred Times of Day") {
                        ForEach(TimeOfDay.allCases) { time in
                            Toggle(time.rawValue, isOn: Binding(
                                get: { selectedTimesOfDay.contains(time) },
                                set: { isOn in
                                    if isOn {
                                        selectedTimesOfDay.insert(time)
                                    } else {
                                        selectedTimesOfDay.remove(time)
                                    }
                                    updatePreference()
                                }
                            ))
                        }
                    }
                    
                    // Days of week section with toggles
                    Section("Preferred Days of Week") {
                        ForEach(DayOfWeek.allCases) { day in
                            Toggle(day.name, isOn: Binding(
                                get: { selectedDaysOfWeek.contains(day) },
                                set: { isOn in
                                    if isOn {
                                        selectedDaysOfWeek.insert(day)
                                    } else {
                                        selectedDaysOfWeek.remove(day)
                                    }
                                    updatePreference()
                                }
                            ))
                        }
                    }
                    
                    Section("Duration Settings") {
                        Stepper("Pre-jog duration: \(preJogDuration) min", value: $preJogDuration, in: 5...60, step: 5)
                            .onChange(of: preJogDuration) { _, _ in updatePreference() }
                            
                        Stepper("Post-jog duration: \(postJogDuration) min", value: $postJogDuration, in: 5...60, step: 5)
                            .onChange(of: postJogDuration) { _, _ in updatePreference() }
                    }
                }
                
                if currentPreference == nil {
                    Section {
                        Text("No preferences found. Please complete the onboarding process first.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Your Preferences")
            .onAppear {
                loadPreferenceData()
            }
        }
    }
    
    // Load current preference data into state variables
    private func loadPreferenceData() {
        guard let preference = currentPreference else { return }
        
        selectedTimesOfDay = Set(preference.preferredTimesOfDay)
        selectedDaysOfWeek = Set(preference.preferredDaysOfWeek ?? [])
        preJogDuration = preference.preJogDuration
        postJogDuration = preference.postJogDuration
    }
    
    // Update the existing preference with current state
    private func updatePreference() {
        guard let preference = currentPreference else { return }
        
        // Update the model with current selections
        preference.preferredTimesOfDay = Array(selectedTimesOfDay)
        preference.preferredDaysOfWeek = Array(selectedDaysOfWeek)
        preference.preJogDuration = preJogDuration
        preference.postJogDuration = postJogDuration
        
        // Save the changes
        do {
            try modelContext.save()
        } catch {
            print("Failed to save preferences: \(error)")
        }
    }
}

/// Create a preview with sample data
#Preview {
    let container: ModelContainer = {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            do {
                let container = try ModelContainer(for: PreferencesModel.self, configurations: config)
                
                // Insert sample data
                let samplePreference = PreferencesModel(
                    timeOnFeet: 15,
                    preJogDuration: 15,
                    postJogDuration: 10,
                    timeOfDay: [TimeOfDay.morning, TimeOfDay.evening],
                    dayOfWeek: [DayOfWeek.monday, DayOfWeek.wednesday, DayOfWeek.friday]
                )
                container.mainContext.insert(samplePreference)
                
                return container
            } catch {
                fatalError("Failed to create model container: \(error)")
            }
        }()
    
    PreferencesView()
        .modelContainer(container)
}
    
