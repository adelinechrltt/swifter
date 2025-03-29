//
//  OnboardThanksForLettingUsKnow.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardThanksForLettingUsKnow: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                Spacer()

                // Title
                Text("Thanks for letting us know!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)

                // Subtitle
                Text("Your jogging schedule has been updated accordingly.")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)

                Spacer()

                // Start Jogging Button
                NavigationLink(destination: OnboardPreJogTime()) {
                    Text("Let’s start jogging!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                }

                // Progress Bar
                ProgressView(value: 1.0, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.primary)
                    .frame(height: 6)
                    .padding(.top, 20)

                Spacer()
            }
            .padding(40)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground).ignoresSafeArea())
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardThanksForLettingUsKnow()
}
