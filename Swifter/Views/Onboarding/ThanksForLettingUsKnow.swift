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

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()

                Text("Thanks for letting us know!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.black)

                Text("Your jogging schedule has been updated accordingly.")
                    .font(.system(size: 19))
                    .foregroundColor(.black)
                
                NavigationLink(destination: PreferencesView()) {
                    Text("Let's start jogging! ")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 180, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                .simultaneousGesture(TapGesture().onEnded { _ in
                    // TODO: replace this block of code with home menu navigation
                })
                
                Spacer()
                
                ProgressView(value: 1, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.black)
                    .frame(height: 4)
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(40)
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

//#Preview {
//    OnboardThanksForLettingUsKnow(tempPreferences: PreferencesModel(
//        timeOfDay: [.morning],
//        dayOfWeek: [.monday, .wednesday, .friday],
//        preJogDuration: 15,
//        postJogDuration: 10
//    ))
//}
