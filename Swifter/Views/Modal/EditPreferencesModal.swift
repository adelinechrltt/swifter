import SwiftUI
import SwiftData

struct EditPreferencesModal: View {
    @Binding var isPresented: Bool

    var modelContext: ModelContext
    @Query private var preferences: [PreferencesModel]

    @State private var selectedTimesOfDay: Set<TimeOfDay> = []
    @State private var selectedDaysOfWeek: Set<DayOfWeek> = []
    @State private var avgTimeOnFeet: Int = 30
    @State private var preJogDuration: Int = 5
    @State private var postJogDuration: Int = 5

    @State private var showSaveAlert = false

    private let columns = Array(repeating: GridItem(.flexible()), count: 4)

    private var currentPreference: PreferencesModel? {
        preferences.first
    }

    var onSave: () -> Void

    init(isPresented: Binding<Bool>, modelContext: ModelContext, onSave: @escaping () -> Void) {
        self._isPresented = isPresented
        self.modelContext = modelContext
        self.onSave = onSave
    }

    var body: some View {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
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

                            Text("Preferred Times of Day").font(.subheadline).bold()

                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(TimeOfDay.allCases) { time in
                                    TimeButton(
                                        title: time.rawValue,
                                        isSelected: selectedTimesOfDay.contains(time),
                                        action: { toggleTimeOfDay(time) }
                                    )
                                }
                            }

                            Text("Preferred Days of the Week").font(.subheadline).bold()

                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(DayOfWeek.allCases) { day in
                                    DayButton(
                                        title: day.name.prefix(3),
                                        isSelected: selectedDaysOfWeek.contains(day),
                                        action: { toggleDayOfWeek(day) }
                                    )
                                }
                            }
                        }

                        Button(action: {
                            showSaveAlert = true
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                        .alert(isPresented: $showSaveAlert) {
                            Alert(
                                title: Text("Save Changes?"),
                                message: Text("Are you sure you want to save your preferences?"),
                                primaryButton: .default(Text("OK")) {
                                    updatePreference()
                                    onSave()
                                    isPresented = false
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal, 20)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.75)
            }
            .frame(maxWidth: 700)
            .transition(.move(edge: .bottom))
            .onAppear {
                loadPreferenceData()
                if let prefs = currentPreference {
                    selectedTimesOfDay = Set(prefs.preferredTimesOfDay)
                    selectedDaysOfWeek = Set(prefs.preferredDaysOfWeek ?? [])
                    avgTimeOnFeet = prefs.jogDuration
                    preJogDuration = prefs.preJogDuration
                    postJogDuration = prefs.postJogDuration
                }
            }
    }

    private func loadPreferenceData() {
        guard let preference = currentPreference else { return }
        selectedTimesOfDay = Set(preference.preferredTimesOfDay)
        selectedDaysOfWeek = Set(preference.preferredDaysOfWeek ?? [])
        avgTimeOnFeet = preference.jogDuration
        preJogDuration = preference.preJogDuration
        postJogDuration = preference.postJogDuration
    }

    private func updatePreference() {
        guard let preference = currentPreference else { return }

        preference.preferredTimesOfDay = Array(selectedTimesOfDay)
        preference.preferredDaysOfWeek = Array(selectedDaysOfWeek)
        preference.jogDuration = avgTimeOnFeet
        preference.preJogDuration = preJogDuration
        preference.postJogDuration = postJogDuration

        do {
            try modelContext.save()
            print("✅ Preferences updated successfully")
        } catch {
            print("❌ Failed to save preferences: \(error)")
        }
    }

    private func toggleTimeOfDay(_ time: TimeOfDay) {
        if selectedTimesOfDay.contains(time) {
            selectedTimesOfDay.remove(time)
        } else {
            selectedTimesOfDay.insert(time)
        }
        updatePreference()
    }

    private func toggleDayOfWeek(_ day: DayOfWeek) {
        if selectedDaysOfWeek.contains(day) {
            selectedDaysOfWeek.remove(day)
        } else {
            selectedDaysOfWeek.insert(day)
        }
        updatePreference()
    }
}

// MARK: - Reusable Buttons

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

// MARK: - Preview

#Preview {
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            let container = try ModelContainer(for: PreferencesModel.self, configurations: config)
            let samplePreference = PreferencesModel(
                timeOnFeet: 15,
                preJogDuration: 15,
                postJogDuration: 10,
                timeOfDay: [.morning, .evening],
                dayOfWeek: [.monday, .wednesday, .friday]
            )
            container.mainContext.insert(samplePreference)
            return container
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }()

    return EditPreferencesModal(isPresented: .constant(true), modelContext: container.mainContext, onSave: {})
}
