//
//  OnboardPreferredJogTime.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardPreferredJogTime: View {
    @State private var selectedTimes: Set<String> = []
    let jogTimes = ["Morning", "Noon", "Afternoon", "Evening"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                // Title
                Text("What’s your preferred jogging time?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Select all that apply.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                
                // Horizontal selection buttons
                HStack(spacing: 10) {
                    ForEach(jogTimes, id: \.self) { time in
                        Button(action: {
                            toggleSelection(for: time)
                        }) {
                            Text(time)
                                .font(.system(size: 13))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(selectedTimes.contains(time) ? Color.primary.opacity(0.8) : Color.clear)
                                .foregroundColor(selectedTimes.contains(time) ? .white : .primary)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                        }
                    }
                }
                
                Spacer()
                
                // Progress Bar
                ProgressView(value: 0.5, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(.gray)
                    .frame(height: 6)
                    .padding(.top, 10)
                
                // Buttons (Skip & Next)
                HStack {
                    // Skip Button
                    NavigationLink(destination: OnboardPreferredDays()) {
                        Text("Skip")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(width: 100, height: 45)
                    }
                    
                    Spacer()

                    // Next Button (Visible only if a selection is made)
                    if !selectedTimes.isEmpty {
                        NavigationLink(destination: OnboardPreferredDays()) {
                            Text("Next")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                                .padding()
                                .frame(width: 150, height: 45)
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.primary, lineWidth: 1))
                        }
                    }
                }
                .padding(.bottom, 40) // Adjust bottom position
                
            }
            .padding(30)
        }
        .navigationBarHidden(true)
    }
    
    private func toggleSelection(for time: String) {
        if selectedTimes.contains(time) {
            selectedTimes.remove(time)
        } else {
            selectedTimes.insert(time)
        }
    }
}

#Preview {
    OnboardPreferredJogTime()
}
