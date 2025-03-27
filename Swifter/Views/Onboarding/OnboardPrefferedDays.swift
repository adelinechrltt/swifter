//
//  OnboardPrefferedJogDays.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardPrefferedJogDays: View {
    @State private var selectedDays: [String] = []
    let jogDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
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
                    .foregroundColor(.black)
                
                Text("Select all that apply.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                
                // Grid selection buttons
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(jogDays, id: \.self) { item in
                        Button(action: {
                            toggleSelection(for: item)
                        }) {
                            Text(item)
                                .font(.system(size: 14))
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity) // Makes button expand horizontally
                                .background(
                                    selectedDays.contains(item) ? Color.black.opacity(0.8) : Color.clear
                                )
                                .foregroundColor(selectedDays.contains(item) ? .white : .black)
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
                    if !selectedDays.isEmpty {
                        NavigationLink(destination: EmptyView()) {
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
        if selectedDays.contains(item) {
            selectedDays.removeAll { $0 == item }
        } else {
            selectedDays.append(item)
        }
    }
}

#Preview {
    OnboardPrefferedJogDays()
}
