import SwiftUI

struct UpcomingSession: View {
    @State private var showProgress = false
    @State private var forceUpdateProgress = false // Add this to force redraws
    
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
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 15) {
            // Header
            HStack {
                Text("Sessions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    viewModel.preferencesModalShown = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .padding(.trailing)
            }
            .padding(.top)
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Upcoming Session Card
                    VStack(spacing: 0) {
                        // Header section
                        HStack {
                            Text("Upcoming jog session at")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.top, 16)
                            Spacer()
                        }
                        
                        Divider()
                            .padding(.top, 8)
                        
                        // Main content
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.timeUntil > 60 * 60 * 24 ? "In \(viewModel.days) days" : "Tomorrow")
                                    .font(.subheadline)
                                
                                Text(dateFormatter.string(from: viewModel.nextStart))
                                    .font(.system(size: 28, weight: .bold))
                                
                                Text("\(timeFormatter.string(from: viewModel.nextStart).lowercased()) - \(timeFormatter.string(from: viewModel.nextEnd).lowercased())")
                                    .font(.subheadline)
                                    .padding(.top, 2)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            
                            Spacer()
                            
                            // Replace with your local icon
                            Image("Swifter.logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 90, height: 90)
                                .foregroundColor(.white)
                                .padding(.trailing, 30)
                        }
                        
                        // Goal section
                        HStack {
                            HStack {
                                Text("Goal: Jog \(viewModel.currentGoal.targetFrequency) times in a week")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    viewModel.goalModalShown = true
                                }) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.black.opacity(0.3))
                                        .clipShape(Circle())
                                }
                                .padding(.leading, 4)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(20)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                    )
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            viewModel.rescheduleSessions(eventStoreManager: eventStoreManager, preferencesManager: preferencesManager, sessionManager: sessionManager)
                        }) {
                            Text("Reschedule")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                        .background(Color.gray.opacity(0.1).cornerRadius(30))
                                )
                        }
                        
                        Button(action: {
                            let flag = viewModel.markSessionAsComplete(sessionManager: sessionManager, goalManager: goalManager)
                            if flag == true {
                                viewModel.completedGoalAlertShown = true
                            } else {
                                viewModel.createNewSession(sessionManager: sessionManager, storeManager: eventStoreManager, preferencesManager: preferencesManager)
                            }
                            
                            // Important: Reset animation flag to force progress update after marking complete
                            showProgress = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
                                showProgress = true
                                forceUpdateProgress.toggle() // Force view update
                            }
                        }) {
                            Text("Mark as Done")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.white))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Weekly Progress Card
                    VStack(spacing: 0) {
                        // Header section
                        HStack {
                            Text("Weekly Progress")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.top, 16)
                            Spacer()
                        }
                        
                        Divider()
                            .padding(.top, 8)
                        
                        // Progress content with gradient stroke
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                                    .frame(width: 100, height: 100)
                                
                                // Gradient progress arc - UPDATED TO TRIGGER ON CHANGES
                                Circle()
                                    .trim(from: 0.0, to: showProgress ? Double(viewModel.currentGoal.progress) / Double(viewModel.currentGoal.targetFrequency) : 0.0)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue, Color.green]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 12
                                    )
                                    .rotationEffect(.degrees(-90))
                                    .frame(width: 100, height: 100)
                                    .animation(.easeOut(duration: 1.0), value: showProgress)
                                    .animation(.easeOut(duration: 1.0), value: viewModel.currentGoal.progress)
                                    .animation(.easeOut(duration: 1.0), value: forceUpdateProgress) // Add this to force the animation to update
                            }
                            .padding(.leading, 20)
                            .padding(.vertical, 20)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(viewModel.currentGoal.progress)/\(viewModel.currentGoal.targetFrequency)")
                                    .font(.system(size: 32, weight: .bold))
                                
                                Text("runs completed this week")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                NavigationLink(destination: AnalyticsView()) {
                                    Text("View Summary")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(colorScheme == .dark ? .black : .white)
                                        .padding(.vertical, 13)
                                        .padding(.horizontal, 24)
                                        .background(colorScheme == .dark ? Color.white : Color.primary)
                                        .cornerRadius(22)
                                }
                                .padding(.top, 8)
                            }
                            .padding(.leading, 24)
                            .padding(.trailing, 20)
                            .padding(.vertical, 20)
                            
                        }
                    }
                    .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color(.systemGray5))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .id(viewModel.currentGoal.progress) // Regenerate view when progress changes
                }
                .padding(.bottom, 20)
            }
            
            
            // Original Tab Bar
            HStack(spacing: 12) {
                Spacer()
                
                NavigationLink(destination: AnalyticsView()) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                NavigationLink(destination: AnalyticsView()) {
                    Image(systemName: "calendar")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.vertical, 20)
            .background(Color.gray.opacity(0.1))
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $viewModel.preferencesModalShown) {
            EditPreferencesModal(isPresented: $viewModel.preferencesModalShown, modelContext: modelContext, onSave: {
                viewModel.rescheduleSessions(eventStoreManager: eventStoreManager, preferencesManager: preferencesManager, sessionManager: sessionManager)
                viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
                // Reset animation to trigger progress update
                showProgress = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showProgress = true
                    forceUpdateProgress.toggle()
                }
            })
            .presentationDetents([.height(600)])
        }
        .sheet(isPresented: $viewModel.goalModalShown) {
            GoalSettingModal(
                isPresented: $viewModel.goalModalShown,
                goalToEdit: viewModel.currentGoal,
                onPreSave: {
                    viewModel.wipeAllSessionsRelatedToGoal(sessionManager: sessionManager, eventStoreManager: eventStoreManager)
                    viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
                },
                onPostSave: {
                    viewModel.createNewSession(sessionManager: sessionManager, storeManager: eventStoreManager, preferencesManager: preferencesManager)
                    viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
                    // Reset animation to trigger progress update after goal changes
                    showProgress = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showProgress = true
                        forceUpdateProgress.toggle()
                    }
                }
            )
            .presentationDetents([.height(300)])
        }
        .alert(isPresented: $viewModel.completedGoalAlertShown) {
            Alert(
                title: Text("Weekly jogging goal completed! 🥳"),
                message: Text("Congratulations! Let's keep up the pace by setting your next weekly goal."),
                dismissButton: .default(Text("OK")) {
                    viewModel.markGoalAsComplete(goalManager: goalManager)
                    viewModel.createNewGoal(goalManager: goalManager)
                    viewModel.goalModalShown = true
                }
            )
        }
        .onAppear {
            viewModel.fetchData(goalManager: goalManager, sessionManager: sessionManager)
            
            eventStoreManager.eventStore.requestAccess(to: .event) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        // The calendar access is granted
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
