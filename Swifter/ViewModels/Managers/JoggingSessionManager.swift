//
//  JoggingSessionManager.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 31/03/25.
//

import SwiftData
import Foundation

class JoggingSessionManager: ObservableObject { // --> observable object supaya bisa dimasukkin as a state object
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// fetch all sessions, sorted by date
    func fetchAllSessions() -> [SessionModel] {
        let descriptor = FetchDescriptor<SessionModel>(
            sortBy: [SortDescriptor(\.startTime, order: .forward)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    /// fetch the next upcoming session
    func fetchLatestSession() -> SessionModel? {
        let currDate = Date()
        
        /// check if session is upcoming or not
        let predicate = #Predicate<SessionModel> { session in
            session.startTime >= currDate
        }

        let descriptor = FetchDescriptor<SessionModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.startTime, order: .forward)]
        )
        
        return try? modelContext.fetch(descriptor).first
    }
    
    /// fetch session by ID
    func fetchSessionById(id: PersistentIdentifier) -> SessionModel? {
        let predicate = #Predicate<SessionModel> { session in
            session.persistentModelID == id
        }
        
        let descriptor = FetchDescriptor<SessionModel>(
            predicate: predicate
        )

        return try? modelContext.fetch(descriptor).first
    }
    
    /// fetch session by Calendar Event ID
    func fetchSessionByCalendarEventId(calendarId: String) -> SessionModel? {
        let predicate = #Predicate<SessionModel> { session in
            session.calendarEventID == calendarId
        }
        
        let descriptor = FetchDescriptor<SessionModel>(
            predicate: predicate
        )

        return try? modelContext.fetch(descriptor).first
    }
    
    func createNewSession(storeManager: EventStoreManager, start: Date, end: Date, sessionType: SessionType) -> PersistentIdentifier? {
        if let id = storeManager.createNewEvent(eventTitle: sessionType.rawValue, startTime: start, endTime: end) {
            let newSession = SessionModel(startTime: start, endTime: end, calendarEventID: id, sessionType: sessionType)
            modelContext.insert(newSession)
            do {
                try modelContext.save()
                print("created new session \(newSession) with ID \(newSession.persistentModelID)")
                print("time: \(newSession.startTime) - \(newSession.endTime)")
                return newSession.persistentModelID
            } catch {
                print("error bro")
            }
        }
        return nil
    }
    
    /// update a session's starting and ending times
    func updateSessionTimes(id: PersistentIdentifier, newStart: Date, newEnd: Date, eventStoreManager: EventStoreManager){
        if let mySession = fetchSessionById(id: id){
            mySession.startTime = newStart
            mySession.endTime = newEnd
            eventStoreManager.setEventTimes(
                id: mySession.calendarEventID,
                newStart: newStart,
                newEnd: newEnd)
            
            do {
                try modelContext.save()
                print("Session times succesfully updated")
                print("Start: \(mySession.startTime)")
                print("End: \(mySession.endTime)")
            } catch {
                print("Error updating session times")
            }

        }
    }
    
    /// update a session's status
    func updateSessionStatus(id: PersistentIdentifier, newStatus: isCompleted){
        if let mySession = fetchSessionById(id: id){
            mySession.status = newStatus
            
            do {
                try modelContext.save()
                print("Updated status to: \(mySession.status)")
            } catch {
                print("Error updating status")
            }

        }
    }
    
    func deleteSession(session: SessionModel){
        modelContext.delete(session)
        do {
               try modelContext.save()
               print("successfully deleted")
           } catch {
               print("error \(error.localizedDescription)")
           }
    }
    
    /// so other viewmodels can save context after updating a session
    func saveContext() {
        do {
            try modelContext.save()
            print("context saved")
        } catch {
            print("error bro: \(error.localizedDescription)")
        }
    }
}
