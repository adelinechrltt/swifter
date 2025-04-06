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

    /// no need to use published wrapper here
    /// because computed property uses published variables
    /// so if the published variables' values change, so will the computed property's
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
    
    func rescheduleSessions(
        eventStoreManager: EventStoreManager,
        preferencesManager: PreferencesManager,
        sessionManager: JoggingSessionManager
    ) {
        guard let preferences = preferencesManager.fetchPreferences() else { return }

        let totalDuration = nextEnd.timeIntervalSince(nextStart)
        
        if let newTimes = eventStoreManager.findDayOfWeek(duration: totalDuration, preferences: preferences, goal: currentGoal) {
            
            let newStart = newTimes[0]
            var cursor = newStart
            
            /// reschedule prejog
            if let preJog = nextPreJog {
                let duration = preJog.endTime.timeIntervalSince(preJog.startTime)
                let newEnd = cursor + duration
                eventStoreManager.setEventTimes(id: preJog.calendarEventID, newStart: cursor, newEnd: newEnd)
                preJog.startTime = cursor
                preJog.endTime = newEnd
                cursor = newEnd
            }
            
            /// reschedule jog
            let jogDuration = nextJog.endTime.timeIntervalSince(nextJog.startTime)
            let jogEnd = cursor + jogDuration
            eventStoreManager.setEventTimes(id: nextJog.calendarEventID, newStart: cursor, newEnd: jogEnd)
            nextJog.startTime = cursor
            nextJog.endTime = jogEnd
            cursor = jogEnd

            /// reschedule postjog
            if let postJog = nextPostJog {
                let duration = postJog.endTime.timeIntervalSince(postJog.startTime)
                let newEnd = cursor + duration
                eventStoreManager.setEventTimes(id: postJog.calendarEventID, newStart: cursor, newEnd: newEnd)
                postJog.startTime = cursor
                postJog.endTime = newEnd
                cursor = newEnd
            }

            sessionManager.saveContext()
            
            print("✅ Sessions successfully rescheduled!")
        } else {
            print("❌ Could not find a suitable time slot for rescheduling.")
        }
    }

}
