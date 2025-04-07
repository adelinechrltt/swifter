import SwiftUI
import SwiftData

struct GoalSettingModal: View {
    //modal
    @Binding var isPresented: Bool
    @StateObject private var viewModel: EditGoalViewModel
        let goalToEdit: GoalModel

        @Environment(\.modelContext) private var modelContext
        private var goalManager: GoalManager {
            GoalManager(modelContext: modelContext)
        }

        @State private var showSaveAlert = false

        init(isPresented: Binding<Bool>, goalToEdit: GoalModel) {
            self._isPresented = isPresented
            self.goalToEdit = goalToEdit
            _viewModel = StateObject(wrappedValue: EditGoalViewModel())
        }
    
    var body: some View {
        ZStack {
            // Transparent background that covers the entire screen
            Color.clear.edgesIgnoringSafeArea(.all)
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
                            // Show confirmation alert instead of saving directly
                            showSaveAlert = true
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
                                    if viewModel.targetFrequency > 1 {
                                        viewModel.targetFrequency -= 1
                                    }
                                }) {
                                    Text("-")
                                        .font(.title2)
                                        .frame(width: 40, height: 30)
                                        .background(Color(UIColor.secondarySystemBackground)) 
                                        .cornerRadius(8)
                                }
                                
                                Text("\(viewModel.targetFrequency) times / week")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(minWidth: 120, alignment: .center)
                                
                                Button(action: {
                                    if viewModel.targetFrequency < 7 {
                                        viewModel.targetFrequency += 1
                                    }
                                }) {
                                    Text("+")
                                        .font(.title2)
                                        .frame(width: 40, height: 30)
                                        .background(Color(UIColor.secondarySystemBackground)) 
                                        .cornerRadius(8)
                                }
                            }
                        }
                        
                        HStack {
                            Text("Start Date")
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 155, alignment: .leading)
                            
                            Spacer()
                            
                            DatePicker("", selection: $viewModel.startDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("End Date")
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 155, alignment: .leading)
                            
                            Spacer()
                            
                            DatePicker("", selection: $viewModel.endDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(20)
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                .frame(maxWidth: 800)
                .alert(isPresented: $showSaveAlert) {
                    Alert(
                        title: Text("Save Goal"),
                        message: Text("Are you sure you want to save your weekly goal?"),
                        primaryButton: .default(Text("Save")) {
                            viewModel.saveGoal(goalManager: goalManager, goalToEdit: goalToEdit)
                            isPresented = false
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .transition(.move(edge: .bottom))
        }
        .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.fetchData(prevGoal: goalToEdit)
        }
    }
}

// Preview provider with SwiftData removed
struct GoalSettingModal_Preview: PreviewProvider {
    // Preview-only version of the modal without SwiftData dependencies
    struct PreviewGoalSettingModal: View {
        @Binding var isPresented: Bool
        @State private var targetFrequency: Int = 3
        @State private var startDate: Date = Date().addingTimeInterval(-7*24*60*60) // 7 days ago
        @State private var endDate: Date = Date().addingTimeInterval(30*24*60*60)   // 30 days ahead
        @State private var showSaveAlert = false
        
        var body: some View {
            ZStack {
                // Transparent background that covers the entire screen
                Color.clear.edgesIgnoringSafeArea(.all)
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
                                showSaveAlert = true
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
                                            .background(Color(UIColor.secondarySystemBackground))
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
                                            .background(Color(UIColor.secondarySystemBackground))
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
                                    .background(Color(UIColor.secondarySystemBackground))
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
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: 800)
                    .alert(isPresented: $showSaveAlert) {
                        Alert(
                            title: Text("Save Goal"),
                            message: Text("Are you sure you want to save your weekly goal?"),
                            primaryButton: .default(Text("Save")) {
                                isPresented = false
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .transition(.move(edge: .bottom))
            }
            .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
        }
    }
    
    static var previews: some View {
        // Use our preview-specific implementation instead
        PreviewGoalSettingModal(isPresented: .constant(true))
    }
}
