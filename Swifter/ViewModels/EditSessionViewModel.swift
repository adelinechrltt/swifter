//
//  EditSessionViewModel.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 27/03/25.
//

import Foundation
import SwiftUI
import EventKit

final class EditSessionViewModel: ObservableObject {
    
    // injected event store manager
    var eventStoreManager: EventStoreManager
    
    // Selected session properties
    @Published var selectedSession: SessionModel?
    @Published var relatedSessions: [SessionModel] = []
    
    // New scheduled time for the session(s)
    @Published var newStartTime: Date = Date()
    
    init(
        // set with initial values
        eventStoreManager: EventStoreManager
    ) {
        self.eventStoreManager = eventStoreManager
    }
    
    // Load session and related sessions (pre/post jog)
    func loadSession(session: SessionModel, sessionManager: JoggingSessionManager) {
        self.selectedSession = session
        self.newStartTime = session.startTime
        
        // Find related sessions based on timing
        findRelatedSessions(session: session, sessionManager: sessionManager)
    }
    
    // Find sessions that are related (immediately before/after)
    private func findRelatedSessions(session: SessionModel, sessionManager: JoggingSessionManager) {
        relatedSessions = []
        let allSessions = sessionManager.fetchAllSessions()
        
        // Find sessions that start right after our session ends
        // or end right before our session starts
        for s in allSessions {
            if s.persistentModelID != session.persistentModelID {
                // Check if the session is immediately before or after
                if abs(s.endTime.timeIntervalSince(session.startTime)) < 60 || 
                   abs(s.startTime.timeIntervalSince(session.endTime)) < 60 {
                    relatedSessions.append(s)
                }
            }
        }
        
        // Sort related sessions by start time
        relatedSessions.sort { $0.startTime < $1.startTime }
    }
    
    // Reschedule the selected session and its related sessions
    func rescheduleSession(sessionManager: JoggingSessionManager) -> Bool {
        guard let mainSession = selectedSession else { return false }
        
        // Find all sessions in chronological order
        var sessionsToUpdate = [mainSession] + relatedSessions
        sessionsToUpdate.sort { $0.startTime < $1.startTime }
        
        // Calculate the time difference between current and new start time
        let timeDifference = newStartTime.timeIntervalSince(sessionsToUpdate.first!.startTime)
        
        // Update each session
        for session in sessionsToUpdate {
            let newStart = session.startTime.addingTimeInterval(timeDifference)
            let newEnd = session.endTime.addingTimeInterval(timeDifference)
            
            // Print for debugging
            print("Updating session: \(session.sessionType.rawValue)")
            print("From: \(session.startTime) - \(session.endTime)")
            print("To: \(newStart) - \(newEnd)")
            print("Calendar EventID: \(session.calendarEventID)")
            
            // Update in calendar
            eventStoreManager.setEventTimes(
                id: session.calendarEventID,
                newStart: newStart,
                newEnd: newEnd
            )
            
            // Update model
            session.startTime = newStart
            session.endTime = newEnd
        }
        
        // Save changes
        sessionManager.saveContext()
        
        // Print success message
        print("Rescheduled \(sessionsToUpdate.count) sessions successfully")
        return true
    }
}