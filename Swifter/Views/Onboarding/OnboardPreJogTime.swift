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
                
                Text("How much time do you need to prepare before a jog?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .navigationBarBackButtonHidden(true)

                // Custom Stepper using Apple's Native Logic
                HStack {
                    // Minus Button (disabled at 0)
                    Button(action: {
                        if joggingMinutes > 0 {
                            joggingMinutes -= 5
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(joggingMinutes == 0 ? .gray : .black) // Disabled look
                    }
                    .disabled(joggingMinutes == 0) // Prevents negative values

                    Spacer()

                    // Jogging Minutes in the Middle
                    Text("\(joggingMinutes) min")
                        .font(.system(size: 24, weight: .bold))
                        .frame(minWidth: 100)
                        .multilineTextAlignment(.center)

                    Spacer()

                    // Plus Button
                    Button(action: {
                        if joggingMinutes < 120 {
                            joggingMinutes += 5
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 10)

                // Next & Skip Button Row
                HStack {
                    // Skip Button
                    NavigationLink(destination: EmptyView()) {
                        Text("Skip")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding()
                            .frame(width: 100, height: 45)
                    }
                    
                    Spacer()

                    // Next Button
                    NavigationLink(destination: OnboardPreferredJogTime()) {
                        Text("Next")
                            .font(.system(size: 14))
                            .foregroundColor(joggingMinutes > 0 ? .black : .gray)
                            .padding()
                            .frame(width: 150, height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(joggingMinutes > 0 ? Color.black : Color.gray, lineWidth: 1)
                            )
                    }
                    .disabled(joggingMinutes == 0) // Only enabled when value > 0
                }
                .padding(.top, 150)
                .padding(.bottom, 100)

                // Progress Bar
                ProgressView(value: 0.25, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.black)
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
