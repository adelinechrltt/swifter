import SwiftUI

struct OnboardPreferredJogDays: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    private var preferencesManager: PreferencesManager {
        PreferencesManager(modelContext: modelContext)
    }

    @State var daysOfWeek: [DayOfWeek] = []

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()

                // Title
                Text("What’s your preferred jogging days?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.4), value: daysOfWeek)

                Text("Select all that apply.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .transition(.opacity)
                    .animation(.easeIn(duration: 0.3), value: daysOfWeek)

                // Grid selection buttons
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(DayOfWeek.allCases) { day in
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                toggleSelection(for: day)
                            }
                        }) {
                            Text(day.name)
                                .font(.system(size: 14))
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    daysOfWeek.contains(day)
                                        ? (colorScheme == .dark ? Color.white : Color.black)
                                        : Color.clear
                                )
                                .foregroundColor(
                                    daysOfWeek.contains(day)
                                        ? (colorScheme == .dark ? .black : .white)
                                        : .primary
                                )
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                        }
                        .scaleEffect(daysOfWeek.contains(day) ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: daysOfWeek)
                    }
                }
                .padding(.top, 10)

                Spacer()

                // Progress Bar
                ProgressView(value: 0.5, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(.gray)
                    .frame(height: 6)
                    .padding(.top, 10)

                // Buttons (Skip & Next)
                HStack {
                    Button(action: {
                        // Handle skip action
                    }) {
                        Text("Skip")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(width: 100, height: 45)
                    }

                    Spacer()

                    if !daysOfWeek.isEmpty {
                        NavigationLink(destination: OnboardThanksForLettingUsKnow()) {
                            Text("Next")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                                .padding()
                                .frame(width: 150, height: 45)
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.primary, lineWidth: 1))
                        }
                        .simultaneousGesture(TapGesture().onEnded { _ in
                            preferencesManager.setDaysOfWeek(daysOfWeek: daysOfWeek)
                        })
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: daysOfWeek)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding(30)
        }
        .navigationBarHidden(true)
    }

    private func toggleSelection(for day: DayOfWeek) {
        if daysOfWeek.contains(day) {
            daysOfWeek.removeAll { $0 == day }
        } else {
            daysOfWeek.append(day)
        }
    }
}

#Preview {
    OnboardPreferredJogDays()
}
