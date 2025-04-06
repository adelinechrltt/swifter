//
//  OnboardThanksForLettingUsKnow.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI
import SwiftData

struct OnboardThanksForLettingUsKnow: View {
    @Environment(\.modelContext) private var modelContext
    private var preferencesManager: PreferencesManager {
        PreferencesManager(modelContext: modelContext)
    }
    private var goalManager: GoalManager {
        GoalManager(modelContext: modelContext)
    }
    
    @AppStorage("isNewUser") private var isNewUser: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()

            // Title
            Text("Thanks for letting us know!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .transition(.move(edge: .leading).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.4), value: UUID())

            // Subtitle
            Text("Your jogging schedule has been updated accordingly.")
                .font(.system(size: 18))
                .foregroundColor(.secondary)
                .transition(.opacity)
                .animation(.easeIn(duration: 0.3), value: UUID())

            Spacer()

            // Start Jogging Button
            Button {
                isNewUser = false
            } label: {
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
            .transition(.scale)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: UUID())

            // Progress Bar
            ProgressView(value: 1.0, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(.primary)
                .frame(height: 6)
                .padding(.top, 20)

            Spacer()
        }
        .padding(40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        OnboardThanksForLettingUsKnow()
    }
}
