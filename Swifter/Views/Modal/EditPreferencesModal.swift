import SwiftUI

struct EditPreferencesModal: View {
    @Binding var isPresented: Bool
    
    // State Variables
    @State private var avgTimeOnFeet: Int = 30
    @State private var preJogDuration: Int = 5
    @State private var postJogDuration: Int = 5
    @State private var preferredTime: String = "Morning"
    @State private var preferredDay: String = "Monday"
    
    let timeOptions = ["Morning", "Afternoon", "Evening"]
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ZStack {
            Color.primary.opacity(0.2) // Dynamic background
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { isPresented = false }
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    // Title & Back Button
                    HStack {
                        Button(action: { isPresented = false }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Text("Edit Preferences")
                            .font(.headline)
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Avg Time On Feet (Required)").font(.subheadline).bold()
                        Stepper("\(avgTimeOnFeet) minutes", value: $avgTimeOnFeet, in: 5...120, step: 5)
                        
                        Text("Avg Pre Jog Duration").font(.subheadline).bold()
                        Stepper("\(preJogDuration) minutes", value: $preJogDuration, in: 0...60, step: 5)
                        
                        Text("Avg Post Jog Duration").font(.subheadline).bold()
                        Stepper("\(postJogDuration) minutes", value: $postJogDuration, in: 0...60, step: 5)
                        
                        Text("Preferred Time of the Day").font(.subheadline).bold()

                        Picker("Select Time", selection: $preferredTime) {
                            ForEach(timeOptions, id: \.self) { Text($0) }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Text("Preferred Day of the Week").font(.subheadline).bold()

                        Picker("Select Day", selection: $preferredDay) {
                            ForEach(daysOfWeek, id: \.self) { Text($0) }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Button(action: { isPresented = false }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(20)
                .background(Color(UIColor.systemBackground)) // Adapt to system theme
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: 700)
            .transition(.move(edge: .bottom))
        }
    }
}

// MARK: - Previews
struct CombinedModals_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EditPreferencesModal(isPresented: .constant(true))
            }
            .previewDevice("iPhone 16 Pro")
            .previewDisplayName("Edit Preferences")
            
            NavigationView {
                EditPreferencesModal(isPresented: .constant(true))
            }
            .previewDevice("iPhone 16 Pro")
            .previewDisplayName("Goal Setting")
        }
    }
}
