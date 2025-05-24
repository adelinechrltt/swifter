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

func sessionModelToDTO(model: SessionModel) -> SessionDTO? {
    do {
        let encoder = JSONEncoder()
        let idData = try encoder.encode(model.persistentModelID)
        let idString = idData.base64EncodedString()
        
        return SessionDTO(
            id: idString,
            startTime: model.startTime,
            endTime: model.endTime,
            calendarEventId: model.calendarEventID,
            sessionType: model.sessionType.rawValue,
            status: model.status.rawValue
        )
    } catch {
        print("Error encoding PersistentIdentifier to String: \(error)")
        return nil
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

func goalModelToDTO(model: GoalModel) -> GoalDTO? {
    do {
        let encoder = JSONEncoder()
        let idData = try encoder.encode(model.persistentModelID)
        let idString = idData.base64EncodedString()
        
        return GoalDTO(
            id: idString,
            targetFrequency: model.targetFrequency,
            startDate: model.startDate,
            endDate: model.endDate,
            progress: model.progress,
            status: model.status.rawValue
        )
    } catch {
        print("Error encoding PersistentIdentifier to String: \(error)")
        return nil
    }
}
