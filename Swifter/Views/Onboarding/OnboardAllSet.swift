import SwiftUI

struct OnboardAllSet: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()

                // Main Title
                Text("Great! We’re all set.")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)

                // Supporting Text
                Text("Thanks for letting us get to know you a little bit better. We’ve scheduled your next jogging session!")
                    .font(.system(size: 18))
                    .foregroundColor(.primary)

                Text("Before we start, do you want to further customize your preferences?")
                    .font(.system(size: 18))
                    .foregroundColor(.primary)

                // "Yes, please" Button
                NavigationLink(destination: OnboardPreJogTime()) {
                    Text("Yes, please")
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .padding()
                        .frame(width: 130, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                }
                
                // "Maybe Later" Button
                NavigationLink(destination: EmptyView()) { // Replace `EmptyView()` with your home screen view
                    HStack(spacing: 5) {
                        Text("Maybe Later")
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                            .opacity(0.6)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                            .opacity(0.6)
                            .padding(.leading, -2)
                    }
                    .frame(width: 130, height: 40) // Ensures full tap area
                }
                .padding(.top, -15)

                Spacer()
                
                // Progress Indicator
                ProgressView(value: 1, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.primary)
                    .frame(height: 4)
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensures text is left-aligned
            .padding(40)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Previews
struct OnboardAllSet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardAllSet()
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("Light Mode")
            
            OnboardAllSet()
                .previewDevice("iPhone 14 Pro")
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
