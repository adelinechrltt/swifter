//
//  OnboardPostJogTime.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI
import SwiftData

struct OnboardPostJogTime: View {
    @Environment(\.modelContext) private var modelContext
    private var preferencesManager: PreferencesManager {
        PreferencesManager(modelContext: modelContext)
    }
    
    @State private var postJogDuration: Int = 0  // Default value

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                Text("How long do you usually cool down after jogging?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .navigationBarBackButtonHidden(true)

                // Custom Stepper using Apple's Native Logic
                HStack {
                    // Minus Button (disabled at 0)
                    Button(action: {
                        if postJogDuration > 0 {
                            postJogDuration -= 5
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(postJogDuration == 0 ? .gray : .black)
                    }
                    .disabled(postJogDuration == 0)

                    Spacer()

                    Text("\(postJogDuration) min")
                        .font(.system(size: 24, weight: .bold))
                        .frame(minWidth: 100)
                        .multilineTextAlignment(.center)

                    Spacer()

                    Button(action: {
                        if postJogDuration < 120 {
                            postJogDuration += 5
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 10)

                HStack {
                    NavigationLink(destination: EmptyView()) {
                        Text("Skip")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding()
                            .frame(width: 100, height: 45)
                    }
                    
                    Spacer()

                    NavigationLink(destination: OnboardPreferredJogTime()) {
                        Text("Next")
                            .font(.system(size: 14))
                            .foregroundColor(postJogDuration > 0 ? .black : .gray)
                            .padding()
                            .frame(width: 150, height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(postJogDuration > 0 ? Color.black : Color.gray, lineWidth: 1)
                            )
                    }
                    .disabled(postJogDuration == 0)
                    .simultaneousGesture(TapGesture().onEnded { _ in
                        preferencesManager.setPostjogTime(postjogTime: postJogDuration)
                    })
                }
                .padding(.top, 150)
                .padding(.bottom, 100)

                ProgressView(value: 0.5, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.black)
                    .frame(height: 4)
                    .padding(.top, 10)
            }
            .padding(30)
        }
        .navigationBarHidden(true)
//        .onAppear {
//            // Set initial value from the preferences if available
//            postJogDuration = tempPreferences.postJogDuration
//        }
    }
}

#Preview {
    OnboardPostJogTime()
}
