//
//  CalendarViewModel.swift
//  Swifter
//
//  Created by Teuku Fazariz Basya on 03/04/25.
//

import Foundation
import SwiftUI
import EventKit

class CalendarViewModel: ObservableObject {
    private let eventStoreManager = EventStoreManager()
    
    @Published var events: [Int: [Event]] = [:]
    @Published var hasCalendarAccess = false
    
    init() {
        checkCalendarAccess()
    }
    
    func checkCalendarAccess() {
        eventStoreManager.requestAccess { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.hasCalendarAccess = true
                case .failure:
                    self.hasCalendarAccess = false
                }
            }
        }
    }
    
    func fetchEventsForMonth(year: Int, month: Int) {
        guard hasCalendarAccess else { return }
        
        // Create date range for the entire month
        var startComponents = DateComponents()
        startComponents.year = year
        startComponents.month = month
        startComponents.day = 1
        startComponents.hour = 0
        startComponents.minute = 0
        
        var endComponents = DateComponents()
        endComponents.year = year
        endComponents.month = month + 1
        endComponents.day = 0  // Last day of month
        endComponents.hour = 23
        endComponents.minute = 59
        
        let calendar = Calendar.current
        let startDate = calendar.date(from: startComponents)!
        let endDate = calendar.date(from: endComponents)!
        
        // Fetch calendar events
        let predicate = eventStoreManager.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let ekEvents = eventStoreManager.eventStore.events(matching: predicate)
        
        // Convert to our Event model and organize by day
        var newEvents = [Int: [Event]]()
        
        for ekEvent in ekEvents {
            let day = calendar.component(.day, from: ekEvent.startDate)
            let hour = calendar.component(.hour, from: ekEvent.startDate)
            let minute = calendar.component(.minute, from: ekEvent.startDate)
            
            // Format time
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            let timeString = timeFormatter.string(from: ekEvent.startDate)
            
            // Create color from calendar color
            let calendarColor = Color(UIColor(cgColor: ekEvent.calendar.cgColor))
            
            let event = Event(
                title: ekEvent.title ?? "Untitled Event",
                time: timeString,
                color: calendarColor
            )
            
            if newEvents[day] != nil {
                newEvents[day]?.append(event)
            } else {
                newEvents[day] = [event]
            }
        }
        
        DispatchQueue.main.async {
            self.events = newEvents
        }
    }
    
    func fetchEventsForDay(year: Int, month: Int, day: Int) -> [Event] {
        return events[day] ?? []
    }
    
    func hasEventsOnDay(day: Int) -> Bool {
        return events[day]?.isEmpty == false
    }
}
