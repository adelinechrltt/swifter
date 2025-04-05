import SwiftUI

struct UpcomingSession: View {
    
    @Environment(\.modelContext) private var modelContext
    private var goalManager: GoalManager {
        GoalManager(modelContext: modelContext)
    }
    private var sessionManager: JoggingSessionManager {
        JoggingSessionManager(modelContext: modelContext)
    }
    
    @StateObject private var viewModel = UpcomingSessionViewModel()
    
    private let formatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM yyyy"
        return formatter
    }()

    private let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:m a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()

    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 6) {
                            Text("Upcoming Session")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.primary)
                            
                            Text(viewModel.nextSession.startTime.timeIntervalSinceNow > 60*60*24 ? "Next jog session in:" : "Next jogging session at")
                                .font(.system(size: 15))
                                .foregroundColor(Color.secondary)
                            
                        }
                        .padding(.bottom, 30)
                        
                        // Session Card
                        VStack(spacing: 14) {
                            Text(viewModel.nextSession.startTime.timeIntervalSinceNow > 60*60*24 ? "\(Int(ceil(viewModel.nextSession.startTime.timeIntervalSinceNow/86400))) days" : "Tomorrow")
                                .font(.system(size: 15))
                                .foregroundColor(Color.secondary)
                            
                            Text("\(formatter1.string(from: viewModel.nextSession.startTime))")
                                .font(.system(size: 35, weight: .bold))
                                .foregroundColor(Color.primary)
                            Text("\(formatter2.string(from: viewModel.nextSession.startTime)) - \(formatter2.string(from: viewModel.nextSession.endTime))")
                                .font(.system(size: 16))
                                .foregroundColor(Color.secondary)
                            
                            HStack(spacing: 8) {
                                Text("Goal: Jog \(viewModel.currentGoal.targetFrequency) times in a week")
                                    .font(.system(size: 14))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(Color(.systemFill))
                                    .cornerRadius(12)
                                    .foregroundColor(Color.primary)
                                
                                Image(systemName: "pencil")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.primary)
                            }
                        }
                        .padding(18)
                        .frame(maxWidth: geometry.size.width * 0.9)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                        .padding(.bottom, 28)
                        
                        // Action Buttons
                        HStack(spacing: 12) {
                            Button(action: {}) {
                                Text("Reschedule")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color(.tertiarySystemFill))
                                    .foregroundColor(Color.primary)
                                    .cornerRadius(18)
                            }
                            
                            Button(action: {}) {
                                Text("Mark as Done")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.primary)
                                    .foregroundColor(Color(.systemBackground))
                                    .cornerRadius(18)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                        Spacer()
                        
                        // Progress Circle
                        ZStack {
                            Circle()
                                .stroke(Color(.systemGray4), lineWidth: 12)
                                .frame(width: 240, height: 240)
                            
                            Circle()
                                .trim(from: 0.0, to: Double(viewModel.currentGoal.progress) / Double(viewModel.currentGoal.targetFrequency))
                                .stroke(Color.primary, lineWidth: 10)
                                .rotationEffect(.degrees(-90))
                                .frame(width: 240, height: 240)
                            
                            
                            VStack(spacing: 8) {
                                Text("This Week")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.secondary)
                                
                                Text("\(viewModel.currentGoal.progress)/\(viewModel.currentGoal.targetFrequency)")
                                    .font(.system(size: 38, weight: .bold))
                                    .foregroundColor(Color.primary)
                                
                                Text("Runs Completed")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.secondary)
                                
                                Button(action: {}) {
                                    HStack{
                                        Text("See More")
                                            .font(.system(size: 12, weight: .medium))
                                            .padding(.vertical, 10)
                                            .background(Color(.systemBackground))
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color.primary)
                                    }.padding(.horizontal)
                                        .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.primary, lineWidth: 1.5)
                                    )
                                    .foregroundColor(Color.primary)
                                }
                                .padding(.top, 12)
                            }
                        }
                        .frame(width: 240, height: 240)
                        .padding(.top, -20)
                        
                        Spacer()
                        /// removed tab bar
                        /// tab bar view will be added in root file
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Tapped gear icon!")
                    }) {
                        Image(systemName: "gearshape")
                    }.foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    UpcomingSession()
}
