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
    
    func checkCalendarAccess() throws{
        /// check if calendar access granted?
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            throw CalendarErrors.accessNotGranted
            return
        }
    }
    
    func requestAccess(completion: @escaping (Result<Void, Error>) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                completion(.success(()))
            } else {
                completion(.failure(error ?? CalendarErrors.accessNotGranted))
            }
        }
    }
    
    /// create a new event, return the event's ID to be used as value for the jogging session instance's property
    func createNewEvent(
        eventTitle: String,
        startTime: Date,
        endTime: Date
    ) -> String? {
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
            return nil
        }
        
        return event.eventIdentifier
    }
    
    // find an event by id
    func findEventById(id: String) -> EKEvent? {
        if let event = eventStore.event(withIdentifier: id) {
            return event
        }
        return nil
    }
    
    
    // update an event's start & end times
    func setEventTimes(id: String, newStart: Date, newEnd: Date){
        if let event = findEventById(id: id){
            event.startDate = newStart
            event.endDate = newEnd
            
            do {
                   try eventStore.save(event, span: .thisEvent, commit: true)
                   print("calendar event updated")
               } catch {
                   print("error bro")
               }
        }
    }
    
    
    func findAvailableSlot(date: Date, duration: TimeInterval) -> [Date]?{
        let calendar = Calendar.current
        
        /// day constraints definition as:
        /// - start of day for running: 6AM
        /// - end of day for running: 9PM
        let startOfDay = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: date)!
        let endOfDay = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: date)!

        /// retrieve all the events in the calendar local DB
        let predicate = eventStore.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: nil)
        let events = eventStore.events(matching: predicate)
            .filter { !$0.isAllDay } /// --> ignore all-day events like Core Challenge or holiday
            .sorted { $0.startDate < $1.startDate } /// sort ascending by start time

        var possibleTimes: [(start: Date, end: Date)] = []
        var lastEndTime = startOfDay

        /// check if free time is available between 6AM (start of day) and before the FIRST event
        if let firstEvent = events.first, firstEvent.startDate.timeIntervalSince(startOfDay) >= duration {
            possibleTimes.append((startOfDay, firstEvent.startDate))
        }

        /// iterate through all events to check if time between events is enough for allotting a session
        for event in events {
            
            /// only update lastEndTime when an event truly extends beyond the previous one
            /// so we ignore events whose duration is still within another event
            if event.endDate > lastEndTime {
                if event.startDate.timeIntervalSince(lastEndTime) >= duration {
                    possibleTimes.append((lastEndTime, event.startDate))
                }
                
                /// if two events exist where event B starts before event A ends, then we consider the end time which is later only
                lastEndTime = max(lastEndTime, event.endDate)
            }
        }

        /// check if free time is available between after LAST event and 9PM (end of day)
        if endOfDay.timeIntervalSince(lastEndTime) >= duration {
            possibleTimes.append((lastEndTime, endOfDay))
        }

        /// if no possible time then return check other day to the function caller
        guard !possibleTimes.isEmpty else {
            print("No free time available to schedule jog.")
            return nil
        }
        
        return [possibleTimes.first!.start, possibleTimes.first!.start + duration]
    }
    
    // TODO: integrate with preferences data
    func findDayOfWeek(date: Date, duration: TimeInterval) -> [Date]?{
        for i in 0...7{
            if let newDate = Calendar.current.date(byAdding: .day, value: i, to: date),
               let availableTime = findAvailableSlot(date: newDate, duration: duration) {
                return availableTime
            }
        }
        return nil
    }
}

