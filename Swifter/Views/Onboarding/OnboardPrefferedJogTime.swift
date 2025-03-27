//
//  OnboardPreferredJogTime.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardPreferredJogTime: View {
    @State private var selectedTimes: [String] = []
    let jogTimes = ["Morning", "Noon", "Afternoon", "Evening"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                // Title
                Text("What’s your preferred jogging time?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Select all that apply.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                // Horizontal selection buttons
                HStack(spacing: 10) {
                    ForEach(jogTimes, id: \.self) { item in
                        Button(action: {
                            toggleSelection(for: item)
                        }) {
                            Text(item)
                                .font(.system(size: 13))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(
                                    selectedTimes.contains(item) ? Color.black.opacity(0.8) : Color.clear
                                )
                                .foregroundColor(selectedTimes.contains(item) ? .white : .black)
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
                    Button(action: {
                        // Handle skip action
                    }) {
                        Text("Skip")
                        .foregroundColor(.gray)
                        NavigationLink(destination: OnboardPrefferedJogDays()) {
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding()
                        .frame(width: 100, height: 45)
                    }
                    
                    Spacer()

                    // Next Button (Visible only if a selection is made)
                    if !selectedTimes.isEmpty {
                        NavigationLink(destination: OnboardPrefferedJogDays()) {
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
    
    private func toggleSelection(for item: String) {
        if selectedTimes.contains(item) {
            selectedTimes.removeAll { $0 == item }
        } else {
            selectedTimes.append(item)
        }
    }
}

#Preview {
    OnboardPreferredJogTime()
}
