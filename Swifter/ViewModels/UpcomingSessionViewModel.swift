//
//  UpcomingSessionViewModel.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 05/04/25.
//

import Foundation

final class UpcomingSessionViewModel: ObservableObject {
    
    @Published var currentGoal: GoalModel
    @Published var nextSession: SessionModel
    @Published var preferencesModalShown: Bool = false
    @Published var goalModalShown: Bool = false // Add this line
    
    /// init with dummy data
    init(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        self.currentGoal = GoalModel(targetFrequency: 3, startDate: formatter.date(from: "2025/01/01")!, endDate: formatter.date(from: "2025/03/01")!)
        
        self.nextSession = SessionModel(startTime: Date()+3600*48, endTime: Date()+3600*48+30*60, calendarEventID: "lorem ipsum", sessionType: SessionType.prejog)
                                        
        self.currentGoal.progress = 2
    }
    
    func fetchData(goalManager: GoalManager, sessionManager: JoggingSessionManager) {
        if let goals = goalManager.fetchGoals() {
            let sortedGoals = goals.sorted(by: { $0.startDate > $1.startDate })
            self.currentGoal = sortedGoals.first!
        }
        
        let sessions = sessionManager.fetchAllSessions()
        if !sessions.isEmpty {
            self.nextSession = sessions
                .sorted(by: { $0.startTime > $1.startTime })
                .first(where: { session in
                    session.sessionType == .prejog || session.sessionType == .jogging
                })!
        }
    }
}
