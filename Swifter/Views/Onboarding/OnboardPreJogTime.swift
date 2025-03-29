//
//  OnboardPreJogTime.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardPreJogTime: View {
    @State private var joggingMinutes: Int = 0  // Default value

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                // Title
                Text("How much time do you need to prepare before a jog?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .navigationBarBackButtonHidden(true)

                // Custom Stepper
                HStack {
                    // Minus Button (disabled at 0)
                    Button(action: { joggingMinutes = max(0, joggingMinutes - 5) }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(joggingMinutes == 0 ? .gray : .primary)
                    }
                    .disabled(joggingMinutes == 0)

                    Spacer()

                    // Jogging Minutes Display
                    Text("\(joggingMinutes) min")
                        .font(.system(size: 24, weight: .bold))
                        .frame(minWidth: 100)
                        .multilineTextAlignment(.center)

                    Spacer()

                    // Plus Button (capped at 120)
                    Button(action: { joggingMinutes = min(120, joggingMinutes + 5) }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.top, 10)

                // Next & Skip Button Row
                HStack {
                    // Skip Button
                    NavigationLink(destination: OnboardPreferredJogTime()) {
                        Text("Skip")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(width: 100, height: 45)
                    }
                    
                    Spacer()

                    // Next Button (Disabled at 0)
                    NavigationLink(destination: OnboardPreferredJogTime()) {
                        Text("Next")
                            .font(.system(size: 14))
                            .foregroundColor(joggingMinutes > 0 ? .primary : .secondary)
                            .padding()
                            .frame(width: 150, height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(joggingMinutes > 0 ? Color.primary : Color.secondary, lineWidth: 1)
                            )
                    }
                    .disabled(joggingMinutes == 0)
                }
                .padding(.top, 150)
                .padding(.bottom, 100)

                // Progress Bar
                ProgressView(value: 0.25, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(.primary)
                    .frame(height: 4)
                    .padding(.top, 10)
            }
            .padding(30)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardPreJogTime()
}
