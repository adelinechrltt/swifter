import SwiftUI

struct UpcomingSession: View {
    @State private var showProgress = false
    
    @EnvironmentObject private var eventStoreManager: EventStoreManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    private var goalManager: GoalManager {
        GoalManager(modelContext: modelContext)
    }
    private var sessionManager: JoggingSessionManager {
        JoggingSessionManager(modelContext: modelContext)
    }
    private var preferencesManager: PreferencesManager {
        PreferencesManager(modelContext: modelContext)
    }
    
    @StateObject private var viewModel = UpcomingSessionViewModel()
    
    private let formatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM yyyy"
        return formatter
    }()
    
    private let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 6) {
                        Text("Upcoming Session")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.primary)
                        
                        Text(viewModel.nextStart.timeIntervalSinceNow > 60*60*24 ? "Next jog session in:" : "Next jogging session at")
                            .font(.system(size: 15))
                            .foregroundColor(Color.secondary)
                    }
                    .padding(.bottom, 30)
                    
                    // Session Card
                    VStack(spacing: 14) {
                        Text(viewModel.timeUntil > 60 * 60 * 24 ? "\(viewModel.days) days" : "Tomorrow")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white)
                        
                        Text("\(formatter1.string(from: viewModel.nextStart))")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(Color.white)
                        Text("\(formatter2.string(from: viewModel.nextStart)) - \(formatter2.string(from: viewModel.nextEnd))")
                            .font(.system(size: 16))
                            .foregroundColor(Color.white)
                        
                        HStack(spacing: 8) {
                            Text("Goal: Jog \(viewModel.currentGoal.targetFrequency) times in a week")
                                .font(.system(size: 14))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Color(.systemFill))
                                .cornerRadius(12)
                                .foregroundColor(Color.white)
                            
                            Image(systemName: "pencil")
                                .font(.system(size: 22.5))
                                .foregroundColor(Color.white)
                                .onTapGesture {
                                    viewModel.goalModalShown = true
                                }
                        }
                    }
                    .padding(18)
                    .frame(maxWidth: geometry.size.width * 0.9)
                    .background(
                        Color(uiColor: colorScheme == .dark ? .systemGray6 : .black)
                    )
                    .cornerRadius(20)
                    .padding(.bottom, 28)
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            viewModel.rescheduleSessions(eventStoreManager: eventStoreManager, preferencesManager: preferencesManager, sessionManager: sessionManager)
                        }) {
                            Text("Reschedule")
                                .font(.system(size: 15, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 22)
                                .background(Color(.tertiarySystemFill))
                                .foregroundColor(Color.primary)
                                .cornerRadius(18)
                        }
                        .contentShape(Rectangle())
                        Button(action: {
                            let flag = viewModel.markSessionAsComplete(sessionManager: sessionManager, goalManager: goalManager)
                            if flag == true {
                                viewModel.completedGoalAlertShown = true
                            } else {
                                print("flag is false?")
                                viewModel.createNewSession(sessionManager: sessionManager, storeManager: eventStoreManager, preferencesManager: preferencesManager)
                            }
                        }) {
                            Text("Mark as Done")
                                .font(.system(size: 15, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 22)
                                .background(Color.primary)
                                .foregroundColor(Color(.systemBackground))
                                .cornerRadius(18)
                        }
                        .contentShape(Rectangle())
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
                            .trim(from: 0.0, to: showProgress ? Double(viewModel.currentGoal.progress) / Double(viewModel.currentGoal.targetFrequency) : 0.0)
                            .stroke(Color.primary, lineWidth: 10)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 240, height: 240)
                            .animation(.easeOut(duration: 1.0).delay(0.2), value: showProgress)
                        
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
                            
                            NavigationLink(destination: AnalyticsView()) {
                                HStack {
                                    Text("See More")
                                        .font(.system(size: 12, weight: .medium))
                                        .padding(.vertical, 10)
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
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        viewModel.preferencesModalShown = true
                    } label: {
                        Image(systemName: "gearshape")
                    }.foregroundColor(.primary)
                }
            }
            // TODO: sheet refactor
            .sheet(isPresented: $viewModel.preferencesModalShown){
                EditPreferencesModal(isPresented: $viewModel.preferencesModalShown, modelContext: modelContext, onSave: {
                    viewModel.rescheduleSessions(eventStoreManager: eventStoreManager, preferencesManager: preferencesManager, sessionManager: sessionManager)
                    viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
                })
                .presentationDetents([.height(600)])
            }


            .sheet(isPresented: $viewModel.goalModalShown) {
                GoalSettingModal(
                    isPresented: $viewModel.goalModalShown,
                    goalToEdit: viewModel.currentGoal,
                    onPreSave:
                        {
                            viewModel.wipeAllSessionsRelatedToGoal(sessionManager: sessionManager, eventStoreManager: eventStoreManager)
                            viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
                        },
                    onPostSave: {
                        viewModel.createNewSession(sessionManager: sessionManager, storeManager: eventStoreManager, preferencesManager: preferencesManager)
                        viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
                        
                    }
                )
                .presentationDetents([.height(300)])

            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.completedGoalAlertShown) {
            Alert(
                title: Text("Weekly jogging goal completed! 🥳"),
                message: Text("Congratulations! Let's keep up the pace by setting your next weekly goal."),
                dismissButton: .default(Text("OK")) {
                    viewModel.markGoalAsComplete(goalManager: goalManager)
                    viewModel.createNewGoal(goalManager: goalManager)
                    viewModel.goalModalShown = true
                })
            //        .onChange(of: viewModel.currentGoal.progress) { _ in
            //            guard !viewModel.checkIfGoalCompleted() else {
            //                viewModel.completedGoalAlertShown = true
            //                return
            //            }
            //
            //            viewModel.createNewSession(sessionManager: sessionManager, storeManager: eventStoreManager, preferencesManager: preferencesManager)
            //            viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
            //        }
        }
        .onAppear {
                    viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
                    
                    eventStoreManager.eventStore.requestAccess(to: .event) { granted, error in
                        DispatchQueue.main.async {
                            if granted {
                                //                                viewModel.scheduleFirstJog(sessionManager: sessionManager, storeManager: eventStoreManager)
                            } else {
                                print("❌ Calendar access not granted.")
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showProgress = true
                        }
                    }
                }
            }
        }

#Preview {
    NavigationView {
        UpcomingSession()
            .environmentObject(EventStoreManager())
    }
}
