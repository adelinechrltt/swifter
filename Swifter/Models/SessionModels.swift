//
//  JogSession.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 26/03/25.
//

import Foundation
import EventKit

enum SessionType {
    case prejog
    case jogging
    case postjog
}

enum isCompleted : String {
    case completed = "Done"
    case incomplete = "Not started yet"
    case missed = "Missed"
}

@Observable
class SessionModel: Identifiable {
    let id = UUID()
        
    var startTime: Date
    var endTime: Date
    var distance: Int?
    var calendarEvent: EKEvent
    
    // enums
    var sessionType: SessionType
    var status: isCompleted
    
    init(startTime: Date, endTime: Date, calendarEvent: EKEvent, sessionType: SessionType){
        self.startTime = startTime
        self.endTime = endTime
        self.calendarEvent = calendarEvent
        self.sessionType = sessionType
        self.status = isCompleted.incomplete
    }
}
