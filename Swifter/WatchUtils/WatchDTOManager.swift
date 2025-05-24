//
//  WatchDTOManager.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 24/05/25.
//

// iOS App - WatchDataManager.swift
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
    
    func goalDTOtoModel(goal: GoalDTO) -> Data?{
        let goalData: Data?
        do {
            goalData = try encoder.encode(goal)
            print("iOS: GoalDTO encoded successfully.")
        } catch {
            goalData = nil
            print("iOS: ERROR: Failed to encode SessionDTO: \(error.localizedDescription)")
        }
        return goalData
    }
}

// MARK: for all session DTO related functions
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

    func convertSessionDTOtoModel(sessionDTO: SessionDTO) -> SessionModel? {
        guard let sessionID = convertStringToPersistentIdentifier(idString: sessionDTO.id)
        else { return nil }

        guard let session = sessionManager.fetchSessionById(id: sessionID)
        else {
            print("iOS: ERROR: Failed to fetch original SessionModel using ID: \(sessionDTO.id)")
            return nil
        }
        return session
    }
}

// MARK: for all goal DTO related functions
extension WatchDTOManager {
    func encodeGoalDTO(goal: GoalDTO) -> Data? {
        let goalData: Data?
        do {
            goalData = try encoder.encode(session)
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

    func convertGoalDTOtoModel(goalDTO: GoalDTO) -> GoalModel? {
        guard let goalID = convertStringToPersistentIdentifier(idString: goalDTO.id)
        else { return nil }

        guard let goal = goalManager.fetchGoalById(id: goalID)
        else {
            print("iOS: ERROR: Failed to fetch original SessionModel using ID: \(goalID.id)")
            return nil
        }
        return goal
    }
}
