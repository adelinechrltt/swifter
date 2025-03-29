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
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                    .navigationBarBackButtonHidden(true)
                Text("Welcome To Swifter")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black)

                Text("Let's Personalize Your Jogging Experience!")
                    .font(.system(size: 18))
                    .foregroundColor(.black)

                NavigationLink(destination: OnboardTimeOnFeet()) {
                    Text("Start Onboarding")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 150, height: 45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 1))
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.white.ignoresSafeArea())
        }
        .navigationBarHidden(true)
        
    }
}


#Preview {
    OnboardStart()
}
