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
    var tempPreferences: PreferencesModel
    
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
                
                NavigationLink(destination: ContentView()) {
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
                .simultaneousGesture(TapGesture().onEnded {
                    // Save the preferences to SwiftData
                    savePreferences()
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
    
    private func savePreferences() {
        // Create a new preferences instance from tempPreferences
        let newPreferences = PreferencesModel(
            timeOfDay: tempPreferences.preferredTimesOfDay,
            dayOfWeek: tempPreferences.preferredDaysOfWeek,
            preJogDuration: tempPreferences.preJogDuration,
            postJogDuration: tempPreferences.postJogDuration
        )
        
        // Insert into model context (SwiftData)
        modelContext.insert(newPreferences)
        
        do {
            try modelContext.save()
            print("Preferences saved successfully")
        } catch {
            print("Failed to save preferences: \(error)")
        }
    }
}

#Preview {
    OnboardThanksForLettingUsKnow(tempPreferences: PreferencesModel(
        timeOfDay: [.morning],
        dayOfWeek: [.monday, .wednesday, .friday],
        preJogDuration: 15,
        postJogDuration: 10
    ))
}
