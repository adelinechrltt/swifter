import SwiftUI

struct OnboardTimeOnFeet: View {
    @State private var joggingMinutes: Int = 0  // Default value

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                Text("How long do you usually stay on your feet during a jog?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .navigationBarBackButtonHidden(true)

                // Custom Stepper using Apple's Native Logic
                HStack {
                    // Minus Button
                    Button(action: {
                        if joggingMinutes > 0 {
                            joggingMinutes -= 5
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(joggingMinutes == 0 ? .gray : .black) // Gray if disabled
                            .opacity(joggingMinutes == 0 ? 0.5 : 1.0) // Reduce opacity if disabled
                    }
                    .disabled(joggingMinutes == 0) // Disable button at 0

                    Spacer()

                    // Jogging Minutes in the Middle
                    Text("\(joggingMinutes) min")
                        .font(.system(size: 24, weight: .bold))
                        .frame(minWidth: 100)
                        .multilineTextAlignment(.center)

                    Spacer()

                    // Plus Button
                    Button(action: {
                        if joggingMinutes < 120 {
                            joggingMinutes += 5
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 10)

                // Next Button Row
                HStack {
                    Spacer()
                    if joggingMinutes > 0 {
                        NavigationLink(destination: OnboardJoggingFrequency()) {
                            Text("Next")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 150, height: 45)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.black, lineWidth: 1)
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
                ProgressView(value: 0.25, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.black)
                    .frame(height: 4)
                    .padding(.top, 10)
            }
            .padding(30)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardTimeOnFeet()
}
