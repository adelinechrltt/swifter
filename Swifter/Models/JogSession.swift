//
//  JogSession.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 26/03/25.
//

import Foundation
import EventKit

class JogSessioModel: Identifiable {
    let id = UUID()
        
    var startTime: Date
    var endTime: Date
    var distance: Int?
    var calendarEvent: EKEvent
    enum isCompleted: String {
        case completed = "Done"
        case incomplete = "Not started yet"
        case missed = "Missed"
    }
    
    init(startTime: Date, endTime: Date, calendarEvent: EKEvent){
        self.startTime = startTime
        self.endTime = endTime
        self.calendarEvent = calendarEvent
    }
}
