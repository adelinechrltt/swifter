//
//  OnboardAllSet.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardAllSet: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()

                Text("Great! We’re all set.")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.black)

                Text("Thanks for letting us get to know you a little bit better. We’ve scheduled your next jogging session!")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                
                Text("Before we start, do you want to further customize your preferences?")
                    .font(.system(size: 18))
                    .foregroundColor(.black)

              
                NavigationLink(destination: OnboardPreJogTime()) {
                    Text("Yes, please")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 130, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                
                
                NavigationLink(destination: EmptyView()) { // Change `HomePageView()`
                    HStack(spacing: 5) {
                        Text("Maybe Later")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .opacity(0.6)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .opacity(0.6)
                            .padding(.leading, -2)
                    }
                    .frame(width: 130, height: 40) // Ensures full tap area
                }
                .padding(.top, -15)

                Spacer()
                
                ProgressView(value: 1, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.black)
                    .frame(height: 4)
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensures text is left-aligned
            .padding(40)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardAllSet()
}
