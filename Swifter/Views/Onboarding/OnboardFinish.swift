//
//  OnboardFinish.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardFinish: View {
    @Environment(\.colorScheme) var colorScheme  // Detects Dark/Light mode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()

            Text("Thanks for letting us know!")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color.primary)  // Adapts to Light/Dark mode

            Text("Your jogging schedule has been updated accordingly.")
                .font(.system(size: 18))
                .foregroundColor(Color.primary)

            Text("Let’s start jogging! 🏃🏽")
                .font(.system(size: 18))
                .foregroundColor(Color.primary)

            NavigationLink(destination: EmptyView()) {
                Text("Done")
                    .font(.system(size: 14))
                    .foregroundColor(Color.primary)
                    .padding()
                    .frame(width: 130, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.primary, lineWidth: 1)  // Matches text color
                    )
            }

            Spacer()
            
            ProgressView(value: 1, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(Color.primary)  // Adapts dynamically
                .frame(height: 4)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(40)
        .background(Color(.systemBackground)) // Ensures the background matches system mode
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardFinish()
}
