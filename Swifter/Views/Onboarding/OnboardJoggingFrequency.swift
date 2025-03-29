import SwiftUI

struct OnboardJoggingFrequency: View {
    @State private var joggingFrequency: Int = 0 // Default value

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                // Title
                Text("What’s your target jogging frequency for this week?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                // Frequency Selection Row
                HStack {
                    // Minus Button (Disabled at 0)
                    Button(action: {
                        if joggingFrequency > 0 {
                            joggingFrequency -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(joggingFrequency == 0 ? .gray : .primary)
                    }
                    .disabled(joggingFrequency == 0) // Prevents negative values

                    Spacer()

                    // Jogging Frequency Text
                    Text("\(joggingFrequency) times a week")
                        .font(.system(size: 24, weight: .bold))
                        .frame(minWidth: 150)
                        .multilineTextAlignment(.center)

                    Spacer()

                    // Plus Button (Limited to 7)
                    Button(action: {
                        if joggingFrequency < 7 {
                            joggingFrequency += 1
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.top, 10)

                // "Next" Button Row
                HStack {
                    Spacer()
                    if joggingFrequency > 0 {
                        NavigationLink(destination: OnboardAllSet()) {
                            Text("Next")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                                .padding()
                                .frame(width: 150, height: 45)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.primary, lineWidth: 1)
                                )
                        }
                        .padding(.top, 150)
                        .padding(.bottom, 100)
                    } else {
                        Text("Next")
                            .font(.system(size: 14))
                            .frame(width: 150, height: 45)
                            .opacity(0)
                            .padding(.top, 150)
                            .padding(.bottom, 100)
                    }
                }
                
                // Progress Bar
                ProgressView(value: 0.5, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.primary)
                    .frame(height: 4)
                    .padding(.top, 10)
            }
            .padding(30)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Previews
struct OnboardJoggingFrequency_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardJoggingFrequency()
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("Light Mode")
            
            OnboardJoggingFrequency()
                .previewDevice("iPhone 14 Pro")
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
