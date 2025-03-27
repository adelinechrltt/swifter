import SwiftUI

struct GoalSettingModal: View {
    @Binding var isPresented: Bool
    @State private var targetFrequency: Int = 1
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        ZStack {
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
                                .frame(maxWidth: .infinity) // Ensure it takes the full width
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
                                .frame(maxWidth: .infinity) // Ensure it takes the full width
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                .frame(maxWidth: 800)
            }
            .transition(.move(edge: .bottom))
        }
    }
}

struct GoalSettingModal_Preview: PreviewProvider {
    static var previews: some View {
        GoalSettingModal(isPresented: .constant(true))
    }
}
