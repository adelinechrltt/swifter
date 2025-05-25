//
//  WatchConnector.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 16/05/25.
//

import Foundation
import WatchConnectivity
import SwiftData

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    var dtoManager: WatchDTOManager? = nil // Add this property

    init(session: WCSession = .default, dtoManager: WatchDTOManager?) { // Update initializer
        self.session = session
        self.dtoManager = dtoManager // Initialize dtoManager
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func setDTOManager(dtoManager: WatchDTOManager){
        self.dtoManager = dtoManager
    }

    /// initial check if session successfully activated or not
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }

    /// method to send context data to the watch
    func sendUpdatedContext(session: SessionDTO, goal: GoalDTO) {
        print("iOS: sendUpdatedContext called.")
        guard WCSession.default.isPaired, WCSession.default.isReachable else {
            print("iOS: WCSession not paired or reachable. Cannot send context.")
            return
        }

        if let dtoManager = self.dtoManager,
           let sessionData = dtoManager.encodeSessionDTO(session: session),
           let goalData = dtoManager.encodeGoalDTO(goal: goal) {
            do {
                try WCSession.default.updateApplicationContext([
                    "session": sessionData,
                    "goal": goalData
                ])
                print("iOS: SUCCESSFULLY updated application context with session and goal data. Dictionary: \([ "session": sessionData.count, "goal": goalData.count ]) bytes")
            } catch {
                print("iOS: ERROR: Cannot send context data: \(error.localizedDescription)")
            }
        } else {
            print("iOS: ERROR: One or both DTOs failed to encode. Not sending context.")
        }
    }


    /// method for iOS app to respond to messages from watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("iOS: Received message from watch: \(message)")

        // Handle roundtrip test
        if let action = message["action"] as? String, action == "roundtripData" {
            print("iOS: Received roundtripData action from Watch.")

            guard let sessionDataBack = message["sessionData"] as? Data,
                  let goalDataBack = message["goalData"] as? Data else {
                print("iOS: ERROR: Missing sessionData or goalData in roundtrip message.")
                replyHandler(["status": "error", "reason": "Missing data for roundtrip test"])
                return
            }

            guard let dtoManager = self.dtoManager,
                  let receivedSessionDTO = dtoManager.decodeSessionDTO(sessionData: sessionDataBack),
                  let _ = try? dtoManager.decoder.decode(GoalDTO.self, from: goalDataBack) else { // Decode GoalDTO as well
                print("iOS: ERROR: Failed to decode roundtrip DTOs.")
                replyHandler(["status": "error", "reason": "Failed to decode roundtrip DTOs"])
                return
            }

            guard let fetchedSession = dtoManager.sessionDTOtoModel(sessionDTO: receivedSessionDTO) else {
                print("iOS: ERROR: Failed to fetch original SessionModel using ID: \(receivedSessionDTO.id)")
                replyHandler(["status": "failure", "message": "Failed to fetch session"])
                return
            }

            print("iOS: Successfully fetched SessionModel using roundtrip PersistentID string!")
            print("iOS: Fetched SessionModel Calendar Event ID: \(fetchedSession.calendarEventID)")
            print("iOS: Original SessionModel Calendar Event ID: \(fetchedSession.calendarEventID)")
            print("iOS: Fetched SessionModel PersistentID: \(fetchedSession.persistentModelID)")
            print("iOS: DTO Session ID (string): \(receivedSessionDTO.id)")
            print("iOS: --- Full Data Roundtrip Test SUCCESS! ---")
            replyHandler(["status": "success", "message": "Data roundtrip complete and verified!"])
            return
        }

        guard let action = message["action"] as? String else {
            replyHandler(["status": "error", "reason": "No action specified or unhandled action"])
            return
        }

        // Handle other actions based on the 'action' string
        switch action {
        // Example:
        // case "markDone":
        //     if let sessionIDString = message["sessionID"] as? String,
        //        let sessionID = dtoManager.convertStringToPersistentIdentifier(idString: sessionIDString) {
        //         let sessionManager = JoggingSessionManager(modelContext: modelContext)
        //         sessionManager.markSessionAsDone(withID: sessionID)
        //         replyHandler(["status": "success"])
        //     } else {
        //         replyHandler(["status": "error", "reason": "Invalid sessionID"])
        //     }
        default:
            replyHandler(["status": "error", "reason": "Unhandled action: \(action)"])
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive.")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}
