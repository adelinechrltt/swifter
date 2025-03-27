//
//  OnboardFinish.swift
//  SwifterSwiftUi
//
//  Created by Natasya Felicia on 26/03/25.
//

import SwiftUI

struct OnboardFinish: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()

                Text("Thanks for letting us know!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.black)

                Text("Your jogging schedule has been updated accordingly.")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                
                Text("Let’s start jogging! 🏃🏽")
                    .font(.system(size: 18))
                    .foregroundColor(.black)

              
                NavigationLink(destination: EmptyView()) {
                    Text("Done")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 130, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                

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
    OnboardFinish()
}
