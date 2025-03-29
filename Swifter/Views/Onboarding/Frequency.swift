//
//  OnboardJoggingFrequency.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardJoggingFrequency: View {
    @State private var joggingFrequency: Int = 0 // Default value

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                Text("What’s your target jogging frequency for this week?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .navigationBarBackButtonHidden(true)

        
                HStack {
                    // Minus Button (disabled at 0)
                    Button(action: {
                        if joggingFrequency > 0 {
                            joggingFrequency -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(joggingFrequency == 0 ? .gray : .black) // Disabled look
                    }
                    .disabled(joggingFrequency == 0) // Disables button interaction

                    Spacer()

                    // Jogging Frequency in the Middle
                    Text("\(joggingFrequency) times a week")
                        .font(.system(size: 24, weight: .bold))
                        .frame(minWidth: 150)
                        .multilineTextAlignment(.center)

                    Spacer()

                    // Plus Button
                    Button(action: {
                        if joggingFrequency < 7 {
                            joggingFrequency += 1
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 10)

                // Next Button Row
                HStack {
                    Spacer()
                    if joggingFrequency > 0 {
                        NavigationLink(destination: OnboardAllSet()) {
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
                        .padding(.top, 150)
                        .padding(.bottom, 100)
                    } else {
                        Text("Next")
                            .font(.system(size: 14))
                            .frame(width: 150, height: 45)
                            .opacity(0)
                            .padding(.top, 150)
                            .padding(.bottom, 100)
                    }
                }
                
                // Progress Bar
                ProgressView(value: 0.5, total: 1.0)
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
    OnboardJoggingFrequency()
}
