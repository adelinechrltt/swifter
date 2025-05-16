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
    var modelContext: ModelContext? // <-- Add this property
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func setupModelContext(_ context: ModelContext) {
        self.modelContext = context
        print("iOS: WatchConnector modelContext set.")
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
        guard WCSession.default.isPaired else {
            return
        }
        
        let encoder = JSONEncoder()
        
        if let sessionData = try? encoder.encode(session),
           let goalData = try? encoder.encode(goal) {
            do {
                try WCSession.default.updateApplicationContext([
                    "session": sessionData,
                    "goal": goalData
                ])
            } catch {
                print("ahhhhh ERROR CANNOT SEND CONTEXT DATA boooooooo")
            }
        }
    }
    
    /// method for iOS app to respond to messages from watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
            print("iOS: Received message from watch: \(message)")
            
            guard let modelContext = self.modelContext else {
                print("iOS: ERROR: ModelContext is not available in WatchConnector.")
                replyHandler(["status": "error", "reason": "ModelContext not available"])
                return
            }
            
            // This is the new part for the roundtrip test
            if let action = message["action"] as? String, action == "roundtripData" {
                print("iOS: Received roundtripData action from Watch.")
                let decoder = JSONDecoder()
                
                guard let sessionDataBack = message["sessionData"] as? Data,
                      let goalDataBack = message["goalData"] as? Data else {
                    print("iOS: ERROR: Missing sessionData or goalData in roundtrip message.")
                    replyHandler(["status": "error", "reason": "Missing data for roundtrip test"])
                    return
                }
                
                var receivedSessionDTO: SessionDTO?
                var receivedGoalDTO: GoalDTO?

                do {
                    receivedSessionDTO = try decoder.decode(SessionDTO.self, from: sessionDataBack)
                    receivedGoalDTO = try decoder.decode(GoalDTO.self, from: goalDataBack)
                    print("iOS: Successfully decoded roundtrip DTOs from Watch.")
                } catch {
                    print("iOS: ERROR: Failed to decode roundtrip DTOs: \(error.localizedDescription)")
                    replyHandler(["status": "error", "reason": "Failed to decode roundtrip DTOs"])
                    return
                }

                guard let sessionDTO = receivedSessionDTO,
                      let goalDTO = receivedGoalDTO else {
                    print("iOS: ERROR: Decoded DTOs are nil after roundtrip.")
                    replyHandler(["status": "error", "reason": "Decoded DTOs are nil"])
                    return
                }

                // 4) iOS app queries SwiftData to fetch the exact instance based on the persistent identifier
                let sessionManager = JoggingSessionManager(modelContext: modelContext) // Use SessionManager here
                // let goalManager = GoalManager(modelContext: modelContext) // Assuming you have one
                // --- CRITICAL FIX FOR COMPARISON AND PRINTING ---
                guard let sessionIDFromDTOAsPersistentID = convertStringToPersistentIdentifier(idString: sessionDTO.id) else { return }
                
                guard let fetchedSession = sessionManager.fetchSessionById(id: sessionIDFromDTOAsPersistentID) else {
                    print("iOS: ERROR: Failed to fetch original SessionModel using ID: \(sessionDTO.id)")
                    replyHandler(["status": "failure", "message": "Failed to fetch session"])
                    return
                }
                // --- Fetch SessionModel ---
                print("iOS: Successfully fetched SessionModel using roundtrip PersistentID string!")
                print("iOS: Fetched SessionModel Calendar Event ID: \(fetchedSession.calendarEventID)")
                // This print is fine, it's just showing the original value
                print("iOS: Original SessionModel Calendar Event ID: \(fetchedSession.calendarEventID)")


                print("iOS: Fetched SessionModel PersistentID: \(fetchedSession.persistentModelID)") // Print actual PersistentID object
                print("iOS: DTO Session ID (string): \(sessionDTO.id)") // Print the string ID from DTO

                print("iOS: --- Full Data Roundtrip Test SUCCESS! ---")
                replyHandler(["status": "success", "message": "Data roundtrip complete and verified!"])
                return
            }
            
            // --- Existing Message Handling ---
            // Your existing switch statement for other actions (markDone, reschedule)
            // Make sure it doesn't conflict with the "roundtripData" action
            // You might want to put this entire if-let block at the top of your function
            // to handle the new action first.
            
            guard let action = message["action"] as? String else {
                replyHandler(["status": "error", "reason": "No action specified or unhandled action"])
                return
            }
        }
    
    func convertStringToPersistentIdentifier(idString: String) -> PersistentIdentifier? {
        // Attempt to decode the base64 string back into Data
        guard let data = Data(base64Encoded: idString) else {
            print("ERROR: convertStringToPersistentIdentifier: Could not decode base64 string to Data.")
            return nil
        }
        
        // Use JSONDecoder to decode the Data back into a PersistentIdentifier
        let decoder = JSONDecoder()
        do {
            let persistentID = try decoder.decode(PersistentIdentifier.self, from: data)
            print("Successfully converted string to PersistentIdentifier.")
            return persistentID
        } catch {
            // Handle potential decoding errors
            print("ERROR: convertStringToPersistentIdentifier: Failed to decode PersistentIdentifier from Data: \(error.localizedDescription)")
            return nil
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive.")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // When deactivated, the session needs to be re-activated.
        session.activate()
    }
    
}
