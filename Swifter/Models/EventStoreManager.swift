//
//  EventStoreManager.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 26/03/25.
//

import Foundation
import EventKit

// error handling
enum CalendarErrors: Error {
    case accessNotGranted
    
    var errorDescription: String? {
        switch self {
            case .accessNotGranted:
                return "Calendar access is not granted!"
        }
    }
}

final class EventStoreManager: ObservableObject {
    let eventStore = EKEventStore()
    
    func requestAccess(completion: @escaping (Result<Void, Error>) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                completion(.success(()))
            } else {
                completion(.failure(error ?? CalendarErrors.accessNotGranted))
            }
        }
    }
    
    func checkCalendarAccess() throws{
        // check if calendar access granted?
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            throw CalendarErrors.accessNotGranted
            return
        }
    }
    
    func createNewEvent(
        eventTitle: String,
        startTime: Date,
        endTime: Date
    ) {
        // create new event
        let event = EKEvent(eventStore: eventStore)
        event.title = eventTitle
        event.startDate = startTime
        event.endDate = endTime
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            print("✅ Jogging event saved successfully!")
        } catch {
            print("❌ Error saving event: \(error.localizedDescription)")
        }
    }
    
    func findAvailableSlot(date: Date, duration: TimeInterval){
        let calendar = Calendar.current
        
        // define a day as
        // start of day for running: 6AM
        // end of day for running: 9PM
        let startOfDay = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: date)!
        let endOfDay = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: date)!

        // retrieve all the events in the calendar local DB
        let predicate = eventStore.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: nil)
        let events = eventStore.events(matching: predicate).sorted { $0.startDate < $1.startDate }

        var possibleTimes: [(start: Date, end: Date)] = []

        var lastEndTime = startOfDay

        // check if free time is available between 6AM (start of day)
        // and before the FIRST event
        if let firstEvent = events.first, firstEvent.startDate.timeIntervalSince(startOfDay) >= duration {
            possibleTimes.append((startOfDay, firstEvent.startDate))
        }

        // iterate through all events to check if time between events
        // is enough for allotting a session
        for event in events {
            if event.startDate.timeIntervalSince(lastEndTime) >= duration {
                possibleTimes.append((lastEndTime, event.startDate))
            }
            lastEndTime = event.endDate
        }

        // check if free time is available between after LAST event
        // and 9PM (end of day)
        if endOfDay.timeIntervalSince(lastEndTime) >= duration {
            possibleTimes.append((lastEndTime, endOfDay))
        }

        // if no possible time then return
        // check other day via function caller
        guard !possibleTimes.isEmpty else {
            print("No free time available to schedule jog.")
            return
        }
        
        createNewEvent(eventTitle: "lorem ipsum", startTime: possibleTimes.first!.start, endTime: possibleTimes.first!.start + duration)
    }
}

