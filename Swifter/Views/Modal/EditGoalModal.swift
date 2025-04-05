import SwiftUI
import SwiftData

struct GoalSettingModal: View {
    //modal
    @Binding var isPresented: Bool
    @StateObject private var viewModel: EditGoalViewModel
    
    // Initialize with environment-based model context
    init(isPresented: Binding<Bool>, modelContext: ModelContext) {
        self._isPresented = isPresented
        let goalManager = GoalManager(modelContext: modelContext)
        _viewModel = StateObject(wrappedValue: EditGoalViewModel(goalManager: goalManager))
    }
    
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
                            viewModel.saveGoal()
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
                                    if viewModel.targetFrequency > 1 {
                                        viewModel.targetFrequency -= 1
                                    }
                                }) {
                                    Text("-")
                                        .font(.title2)
                                        .frame(width: 40, height: 30)
                                        .background(Color(UIColor.secondarySystemBackground)) // Use adaptive background
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
                                        .background(Color(UIColor.secondarySystemBackground)) // Use adaptive background
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
                                .background(Color(UIColor.secondarySystemBackground)) // Use adaptive background
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
                                .background(Color(UIColor.secondarySystemBackground)) // Use adaptive background
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(20)
                .background(Color(UIColor.systemBackground)) // Use adaptive background
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                .frame(maxWidth: 800)
            }
            .transition(.move(edge: .bottom))
        }
    }
}

// Updated preview that uses a mock ModelContext
struct GoalSettingModal_Preview: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: GoalModel.self, configurations: config)
        
        return GoalSettingModal(isPresented: .constant(true), modelContext: container.mainContext)
    }
}
