//
//  OnboardStart.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardStart: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                
                // Welcome Title
                Text("Welcome To Swifter")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)

                // Subtitle
                Text("Let's personalize your jogging experience!")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)

                // Start Button
                NavigationLink(destination: OnboardTimeOnFeet()) {
                    Text("Start Onboarding")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                        .frame(width: 180, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding(30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(.systemBackground).ignoresSafeArea())
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardStart()
}
