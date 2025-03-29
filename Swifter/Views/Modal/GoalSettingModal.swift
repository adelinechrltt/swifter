import SwiftUI

struct GoalSettingModal: View {
    @Binding var isPresented: Bool
    @State private var targetFrequency: Int = 1
    @State private var startDate = Date()
    @State private var endDate = Date()
    @Environment(\.colorScheme) var colorScheme  // Detects dark/light mode

    var body: some View {
        ZStack {
            // Dim background overlay
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 25) {
                    HStack {
                        Text("Edit Your Weekly Goal")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Button("Save") {
                            isPresented = false
                        }
                        .font(.title3)
                    }

                    VStack(alignment: .leading, spacing: 25) {
                        HStack {
                            Text("Target Jog Frequency")
                                .font(.system(size: 18, weight: .medium))
                            Spacer()

                            HStack(spacing: 0) {
                                Button(action: {
                                    if targetFrequency > 1 {
                                        targetFrequency -= 1
                                    }
                                }) {
                                    Text("-")
                                        .font(.title2)
                                        .frame(width: 40, height: 30)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }

                                Text("\(targetFrequency) times / week")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(minWidth: 120, alignment: .center)

                                Button(action: {
                                    if targetFrequency < 7 {
                                        targetFrequency += 1
                                    }
                                }) {
                                    Text("+")
                                        .font(.title2)
                                        .frame(width: 40, height: 30)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                        }

                        HStack {
                            Text("Start Date")
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 155, alignment: .leading)
                            
                            Spacer()
                            
                            DatePicker("", selection: $startDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }

                        HStack {
                            Text("End Date")
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 155, alignment: .leading)
                            
                            Spacer()
                            
                            DatePicker("", selection: $endDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(20)
                .background(
                    colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground)  // Dynamic modal background
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.2), radius: 10)
                .padding(.horizontal, 20)
                .frame(maxWidth: 800)
                .onAppear {
                    print("Color Scheme: \(colorScheme == .dark ? "Dark" : "Light")")
                }
            }
            .transition(.move(edge: .bottom))
        }
    }
}

// MARK: - Preview
struct GoalSettingModal_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                Color(uiColor: .systemBackground)
                    .edgesIgnoringSafeArea(.all)
                GoalSettingModal(isPresented: .constant(true))
            }
            .preferredColorScheme(.light) // Test in light mode
            
            ZStack {
                Color(uiColor: .systemBackground)
                    .edgesIgnoringSafeArea(.all)
                GoalSettingModal(isPresented: .constant(true))
            }
            .preferredColorScheme(.dark) // Test in dark mode
        }
        .previewDevice("iPhone 14 Pro")
    }
}
