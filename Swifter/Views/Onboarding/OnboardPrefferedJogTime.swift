//
//  OnboardPreferredJogTime.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardPreferredJogTime: View {
    @Environment(\.modelContext) private var modelContext
    @State var tempPreferences: PreferencesModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                // Title
                Text("What's your preferred jogging time?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Select all that apply.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                // Horizontal selection buttons
                HStack(spacing: 10) {
                    ForEach(TimeOfDay.allCases) { time in
                        Button(action: {
                            toggleSelection(for: time)
                        }) {
                            Text(time.rawValue)
                                .font(.system(size: 13))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(
                                    tempPreferences.preferredTimesOfDay.contains(time) ? Color.black.opacity(0.8) : Color.clear
                                )
                                .foregroundColor(tempPreferences.preferredTimesOfDay.contains(time) ? .white : .black)
                                .clipShape(Capsule()) // Rounded fill effect
                                .overlay(
                                    Capsule().stroke(Color.black, lineWidth: 1) // Rounded border
                                )
                        }
                    }
                }
                
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
                    NavigationLink(destination: OnboardPrefferedJogDays(tempPreferences: tempPreferences)) {
                        Text("Skip")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding()
                            .frame(width: 100, height: 45)
                    }
                    
                    Spacer()

                    // Next Button (Visible only if a selection is made)
                    if !tempPreferences.preferredTimesOfDay.isEmpty {
                        NavigationLink(destination: OnboardPrefferedJogDays(tempPreferences: tempPreferences)) {
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
                    }
                }
                .padding(.bottom, 40) // Adjust bottom position
                
            }
            .padding(30)
        }
        .navigationBarHidden(true)
    }
    
    private func toggleSelection(for time: TimeOfDay) {
        if tempPreferences.preferredTimesOfDay.contains(time) {
            tempPreferences.preferredTimesOfDay.removeAll { $0 == time }
        } else {
            tempPreferences.preferredTimesOfDay.append(time)
        }
    }
}

#Preview {
    OnboardPreferredJogTime(tempPreferences: PreferencesModel(timeOfDay: [], dayOfWeek: [], preJogDuration: 15, postJogDuration: 15))
}