//
//  WatchCodables.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 16/05/25.
//

import Foundation
import SwiftData

struct SessionDTO: Codable {
    let id: String
    let startTime: Date
    let endTime: Date
    let calendarEventID: String
    let sessionType: SessionType.RawValue
    let status: isCompleted.RawValue
    
    init(id: String, startTime: Date, endTime: Date, calendarEventId: String, sessionType: SessionType.RawValue, status: isCompleted.RawValue) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.calendarEventID = calendarEventId
        self.sessionType = sessionType
        self.status = status
    }
}

struct GoalDTO: Codable {
    let id: String
    let targetFrequency: Int
    let startDate: Date
    let endDate: Date
    let progress: Int
    let status: GoalStatus.RawValue
    
    init(id: String, targetFrequency: Int, startDate: Date, endDate: Date, progress: Int, status: GoalStatus.RawValue) {
        self.id = id
        self.targetFrequency = targetFrequency
        self.startDate = startDate
        self.endDate = endDate
        self.progress = progress
        self.status = status
    }
}
