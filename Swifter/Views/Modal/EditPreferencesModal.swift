import SwiftUI
import SwiftData

struct EditPreferencesModal: View {
    @Binding var isPresented: Bool
    
    // SwiftData model context
    var modelContext: ModelContext
    
    // Query to fetch preferences
    @Query private var preferences: [PreferencesModel]
    
    // State variables to track user changes
    @State private var selectedTimesOfDay: Set<TimeOfDay> = []
    @State private var selectedDaysOfWeek: Set<DayOfWeek> = []
    @State private var avgTimeOnFeet: Int = 30
    @State private var preJogDuration: Int = 5
    @State private var postJogDuration: Int = 5
    
    // Layout for grid items
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Computed property to get the current preference
    private var currentPreference: PreferencesModel? {
        preferences.first
    }
    
    init(isPresented: Binding<Bool>, modelContext: ModelContext) {
        self._isPresented = isPresented
        self.modelContext = modelContext
    }
    
    var body: some View {
        ZStack {
            Color.primary.opacity(0.2) // Dynamic background
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { isPresented = false }
            
            VStack {
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Title & Back Button
                        HStack {
                            Button(action: { isPresented = false }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                            Text("Edit Preferences")
                                .font(.headline)
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Avg Time On Feet (Required)").font(.subheadline).bold()
                            Stepper("\(avgTimeOnFeet) minutes", value: $avgTimeOnFeet, in: 5...120, step: 5)
                                .onChange(of: avgTimeOnFeet) { _, _ in updatePreference() }
                            
                            Text("Avg Pre Jog Duration").font(.subheadline).bold()
                            Stepper("\(preJogDuration) minutes", value: $preJogDuration, in: 0...60, step: 5)
                                .onChange(of: preJogDuration) { _, _ in updatePreference() }
                            
                            Text("Avg Post Jog Duration").font(.subheadline).bold()
                            Stepper("\(postJogDuration) minutes", value: $postJogDuration, in: 0...60, step: 5)
                                .onChange(of: postJogDuration) { _, _ in updatePreference() }
                            
                            // Times of day selection
                            Text("Preferred Times of Day").font(.subheadline).bold()
                            
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(TimeOfDay.allCases) { time in
                                    TimeButton(
                                        title: time.rawValue,
                                        isSelected: selectedTimesOfDay.contains(time),
                                        action: {
                                            toggleTimeOfDay(time)
                                        }
                                    )
                                }
                            }
                            
                            // Days of week selection
                            Text("Preferred Days of the Week").font(.subheadline).bold()
                            
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(DayOfWeek.allCases) { day in
                                    DayButton(
                                        title: day.name.prefix(3),
                                        isSelected: selectedDaysOfWeek.contains(day),
                                        action: {
                                            toggleDayOfWeek(day)
                                        }
                                    )
                                }
                            }
                        }
                        
                        Button(action: {
                            updatePreference()
                            isPresented = false 
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                    }
                    .padding(20)
                }
                .background(Color(UIColor.systemBackground)) // Adapt to system theme
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.75)
            }
            .frame(maxWidth: 700)
            .transition(.move(edge: .bottom))
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
        avgTimeOnFeet = preference.jogDuration
        preJogDuration = preference.preJogDuration
        postJogDuration = preference.postJogDuration
    }
    
    // Update the existing preference with current state
    private func updatePreference() {
        guard let preference = currentPreference else { return }
        
        // Update the model with current selections
        preference.preferredTimesOfDay = Array(selectedTimesOfDay)
        preference.preferredDaysOfWeek = Array(selectedDaysOfWeek)
        preference.jogDuration = avgTimeOnFeet
        preference.preJogDuration = preJogDuration
        preference.postJogDuration = postJogDuration
        
        // Save the changes
        do {
            try modelContext.save()
            print("✅ Preferences updated successfully")
        } catch {
            print("❌ Failed to save preferences: \(error)")
        }
    }
    
    // Toggle time of day selection
    private func toggleTimeOfDay(_ time: TimeOfDay) {
        if selectedTimesOfDay.contains(time) {
            selectedTimesOfDay.remove(time)
        } else {
            selectedTimesOfDay.insert(time)
        }
        updatePreference()
    }
    
    // Toggle day of week selection
    private func toggleDayOfWeek(_ day: DayOfWeek) {
        if selectedDaysOfWeek.contains(day) {
            selectedDaysOfWeek.remove(day)
        } else {
            selectedDaysOfWeek.insert(day)
        }
        updatePreference()
    }
}

// Reusable button for Time of Day selection
struct TimeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13))
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.primary : Color.clear)
                .foregroundColor(isSelected ? Color(UIColor.systemBackground) : Color.primary)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Reusable button for Day of Week selection
struct DayButton: View {
    let title: String.SubSequence
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13))
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.primary : Color.clear)
                .foregroundColor(isSelected ? Color(UIColor.systemBackground) : Color.primary)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

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
    
    return EditPreferencesModal(isPresented: .constant(true), modelContext: container.mainContext)
}
