//
//  EditSessionViewModel.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 27/03/25.
//

import Foundation
import SwiftUI
import EventKit
import SwiftData

final class EditSessionViewModel: ObservableObject {
    // Dependencies
    var eventStoreManager: EventStoreManager!  // Change from 'let' to 'var'
    var sessionManager: JoggingSessionManager? // Already var, which is good
    
    // Current session being edited
    @Published var currentSession: SessionModel?
    @Published var sessionTitle: String = "Session"
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date().addingTimeInterval(30 * 60)
    
    // Updated init to make eventStoreManager optional
    init(
        eventStoreManager: EventStoreManager? = nil, 
        sessionManager: JoggingSessionManager? = nil,
        session: SessionModel? = nil
    ) {
        self.eventStoreManager = eventStoreManager
        self.sessionManager = sessionManager
        
        if let session = session {
            self.loadSession(session)
        }
    }
    
    func loadSession(_ session: SessionModel) {
        self.currentSession = session
        self.startTime = session.startTime
        self.endTime = session.endTime
        self.sessionTitle = session.sessionType.rawValue
    }
    
    func saveSessionChanges() -> Bool {
        guard let session = currentSession, 
              let sessionManager = sessionManager,
              eventStoreManager != nil // Make sure eventStoreManager is set
        else {
            return false
        }
        
        // Update both the session model and the calendar event
        sessionManager.updateSessionTimes(
            id: session.persistentModelID,
            newStart: startTime,
            newEnd: endTime,
            eventStoreManager: eventStoreManager
        )
        
        return true
    }
    
    func createNewEvent() -> String? {
        return eventStoreManager.createNewEvent(
            eventTitle: sessionTitle,
            startTime: startTime,
            endTime: endTime
        )
    }
}
