//
//  OnboardPrefferedJogDays.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardPreferredJogDays: View {
    @Environment(\.modelContext) private var modelContext
    private var preferencesManager: PreferencesManager {
        PreferencesManager(modelContext: modelContext)
    }

    @State var daysOfWeek: [DayOfWeek] = []

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                // Title
                Text("What's your preferred jogging days?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Select all that apply.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                // Grid selection buttons
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ], spacing: 10) {
                    ForEach(DayOfWeek.allCases) { day in
                        Button(action: {
                            toggleSelection(for: day)
                        }) {
                            Text(day.name)
                                .font(.system(size: 14))
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity) // Makes button expand horizontally
                                .background(
                                    daysOfWeek.contains(day) ? Color.black.opacity(0.8) : Color.clear
                                )
                                .foregroundColor(daysOfWeek.contains(day) ? .white : .black)
                                .clipShape(Capsule()) // Rounded fill effect
                                .overlay(
                                    Capsule().stroke(Color.black, lineWidth: 1) // Rounded border
                                )
                        }
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Progress Bar
                ProgressView(value: 0.5, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.gray)
                    .frame(height: 6)
                    .padding(.top, 10)
                
                // Buttons (Skip & Next)
                HStack {
                    // Skip Button
                    Button(action: {
                        // Handle skip action
                    }) {
                        Text("Skip")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding()
                            .frame(width: 100, height: 45)
                    }
                    
                    Spacer()

                    // Next Button (Visible only if a selection is made)
                    if !daysOfWeek.isEmpty {
                        NavigationLink(destination: OnboardThanksForLettingUsKnow()) {
                            Text("Next")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 150, height: 45)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                        .simultaneousGesture(TapGesture().onEnded { _ in
                            preferencesManager.setDaysOfWeek(daysOfWeek: daysOfWeek)
                        })
                    }
                }
                .padding(.bottom, 40) // Adjust bottom position
                
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

//// Preview needs a temporary PreferencesModel to work
#Preview {
    OnboardPreferredJogDays()
}
