//
//  WatchDTOManager.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 24/05/25.
//

import Foundation
import SwiftData
import WatchConnectivity
import Combine

final class WatchDTOManager: ObservableObject {
    let sessionManager: JoggingSessionManager
    let goalManager: GoalManager
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    init(sessionManager: JoggingSessionManager, goalManager: GoalManager) {
            self.sessionManager = sessionManager
            self.goalManager = goalManager
    }
    
    /// convert base64 string --> persistent identifier
    func convertStringToPersistentIdentifier(idString: String) -> PersistentIdentifier? {
        /// Attempt to decode the base64 string back into Data
        guard let data = Data(base64Encoded: idString) else {
            print("ERROR: convertStringToPersistentIdentifier: Could not decode base64 string to Data.")
            return nil
        }
    
        do {
            let persistentID = try decoder.decode(PersistentIdentifier.self, from: data)
            print("Successfully converted string to PersistentIdentifier.")
            return persistentID
        } catch {
            print("ERROR: convertStringToPersistentIdentifier: Failed to decode PersistentIdentifier from Data: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: DTO encoding and decoding
extension WatchDTOManager {
    func encodeSessionDTO(session: SessionDTO) -> Data? {
        let sessionData: Data?
        do {
            sessionData = try encoder.encode(session)
            print("iOS: SessionDTO encoded successfully.")
        } catch {
            sessionData = nil
            print("iOS: ERROR: Failed to encode SessionDTO: \(error.localizedDescription)")
        }
        return sessionData
    }

    func decodeSessionDTO(sessionData: Data) -> SessionDTO? {
        let sessionDTO: SessionDTO?
        do {
            sessionDTO = try decoder.decode(SessionDTO.self, from: sessionData)
            print("iOS: SessionDTO decoded successfully.")
        } catch {
            sessionDTO = nil
        }
        return sessionDTO
    }
    
    func encodeGoalDTO(goal: GoalDTO) -> Data? {
        let goalData: Data?
        do {
            goalData = try encoder.encode(goal)
            print("iOS: SessionDTO encoded successfully.")
        } catch {
            goalData = nil
            print("iOS: ERROR: Failed to encode SessionDTO: \(error.localizedDescription)")
        }
        return goalData
    }

    func decodeGoalDTO(goalData: Data) -> GoalDTO? {
        let goalDTO: GoalDTO?
        do {
            goalDTO = try decoder.decode(GoalDTO.self, from: goalData)
            print("iOS: SessionDTO decoded successfully.")
        } catch {
            goalDTO = nil
        }
        return goalDTO
    }
}

// MARK: DTO-model conversion
extension WatchDTOManager {
    
    func sessionDTOtoModel(sessionDTO: SessionDTO) -> SessionModel? {
        guard let sessionID = convertStringToPersistentIdentifier(idString: sessionDTO.id)
        else { return nil }

        guard let session = sessionManager.fetchSessionById(id: sessionID)
        else {
            print("iOS: ERROR: Failed to fetch original SessionModel using ID: \(sessionDTO.id)")
            return nil
        }
        return session
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
    
    func goalDTOtoModel(goalDTO: GoalDTO) -> GoalModel? {
        guard let goalID = convertStringToPersistentIdentifier(idString: goalDTO.id)
        else { return nil }

        guard let goal = goalManager.fetchGoalById(id: goalID)
        else {
            print("iOS: ERROR: Failed to fetch original SessionModel using ID: \(goalID.id)")
            return nil
        }
        return goal
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
}

// MARK: access SwiftData as SSOT
extension WatchDTOManager {
    func getLatestSession() -> SessionModel? {
        if let session = sessionManager.fetchLatestSession(){
            return session
        }
        print("OOPS no session! returning nil")
        return nil
    }
    
    func getSessionById(id: String) -> SessionModel? {
        guard let persistentId = convertStringToPersistentIdentifier(idString: id) else {
            print("OOPS cannot convert sessionDTO id to swiftdata persistent id!")
            return nil
        }
        
        return sessionManager.fetchSessionById(id: persistentId)
    }
    
    func getLatestGoal() -> GoalModel? {
        if let goal = goalManager.fetchLatestGoal(){
            return goal
        }
        print("OOPS no goal! returning nil")
        return nil
    }
        
    func getGoalById(id: String) -> GoalModel? {
        guard let persistentId = convertStringToPersistentIdentifier(idString: id) else {
            print("OOPS cannot convert goalDTO id to swiftdata persistent id!")
            return nil
        }
        
        return goalManager.fetchGoalById(id: persistentId)
    }
    
    func markSessionAsCompleted(id: String) {
        guard let persistentId = convertStringToPersistentIdentifier(idString: id) else {
            print("OOPS cannot convert sessionDTO id to swiftdata persistent id!")
            return
        }
        
        sessionManager.updateSessionStatus(id: persistentId, newStatus: .completed)
    }
}
