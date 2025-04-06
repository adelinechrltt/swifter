//
//  UpcomingSessionViewModel.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 05/04/25.
//

import Foundation

final class UpcomingSessionViewModel: ObservableObject {
    
    @Published var currentGoal: GoalModel
    @Published var nextPreJog: SessionModel?
    @Published var nextJog: SessionModel
    @Published var nextPostJog: SessionModel?
    
    var nextStart: Date {
        if let preJog = nextPreJog {
            return min(preJog.startTime, nextJog.startTime)
        } else {
            return nextJog.startTime
        }
    }

    var nextEnd: Date {
        if let postJog = nextPostJog {
            return max(postJog.endTime, nextJog.endTime)
        } else {
            return nextJog.endTime
        }
    }

    /// dummy data
    var timeUntil = TimeInterval(60)
    var days = 4
    
    @Published var preferencesModalShown: Bool = false
    @Published var goalModalShown: Bool = false

    /// init with dummy data
    init(){
        self.currentGoal = GoalModel(targetFrequency: 3, startDate: Date(), endDate: Date()+3600*48+30*60)
        
        self.nextJog = SessionModel(startTime: Date()+3600*48, endTime: Date()+3600*48+30*60, calendarEventID: "lorem ipsum", sessionType: .jogging)
        
        self.currentGoal.progress = 2
    }

    
    func fetchData(goalManager: GoalManager, sessionManager: JoggingSessionManager) {
        if let goals = goalManager.fetchGoals() {
            let sortedGoals = goals.sorted(by: { $0.startDate > $1.startDate })
            if let currGoal = sortedGoals.first {
                self.currentGoal = currGoal
            }
        }
          
        let sessions = sessionManager.fetchAllSessions()
            .filter { $0.status == isCompleted.incomplete}
            .sorted(by: { $0.startTime < $1.startTime })

        self.nextPreJog = sessions.first(where: { $0.sessionType == .prejog })
        self.nextJog = sessions.first(where: { $0.sessionType == .jogging }) ?? self.nextJog
        self.nextPostJog = sessions.first(where: { $0.sessionType == .postjog })
        
        self.timeUntil = nextStart.timeIntervalSinceNow
        self.days = Int(ceil(timeUntil / 86400))
    }
}
