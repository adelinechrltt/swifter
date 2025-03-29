import SwiftUI

struct OnboardPreferredDays: View {
    @State private var selectedDays: Set<String> = []
    let jogDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                // Title
                Text("What’s your preferred jogging days?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Select all that apply.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                
                // Grid selection buttons
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(jogDays, id: \.self) { day in
                        Button(action: {
                            toggleSelection(for: day)
                        }) {
                            Text(day)
                                .font(.system(size: 14))
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(selectedDays.contains(day) ? Color.primary.opacity(0.8) : Color.clear)
                                .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                        }
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Progress Bar
                ProgressView(value: 0.5, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(.gray)
                    .frame(height: 6)
                    .padding(.top, 10)
                
                // Buttons (Skip & Next)
                HStack {
                    // Skip Button
                    Button(action: {
                        // Handle skip action
                    }) {
                        Text("Skip")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(width: 100, height: 45)
                    }
                    
                    Spacer()

                    // Next Button (Visible only if a selection is made)
                    if !selectedDays.isEmpty {
                        NavigationLink(destination: OnboardFinish()) {
                            Text("Next")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                                .padding()
                                .frame(width: 150, height: 45)
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.primary, lineWidth: 1))
                        }
                    }
                }
                .padding(.bottom, 40) // Adjust bottom position
                
            }
            .padding(30)
        }
        .navigationBarHidden(true)
    }
    
    private func toggleSelection(for day: String) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
}

// MARK: - Previews
struct OnboardPreferredDays_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardPreferredDays()
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("Light Mode")
            
            OnboardPreferredDays()
                .previewDevice("iPhone 14 Pro")
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}

