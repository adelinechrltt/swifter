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
        
        guard let action = message["action"] as? String else {
            replyHandler(["status": "error", "reason": "No action specified or unhandled action"])
            return
        }
        
        switch action {
            
        case "requestInitialData":
            print("iOS: Received requestInitialData from watch.")
            guard let dtoManager = self.dtoManager else {
                print("iOS: ERROR: dtoManager not set for initial data request.")
                replyHandler(["error": "Internal error on iOS"])
                return
            }
            
            if let currentSession = dtoManager.getLatestSession(),
               let currentGoal = dtoManager.getLatestGoal() {
                if let sessionDTO = dtoManager.sessionModelToDTO(model: currentSession),
                   let goalDTO = dtoManager.goalModelToDTO(model: currentGoal),
                   let sessionData = dtoManager.encodeSessionDTO(session: sessionDTO),
                   let goalData = dtoManager.encodeGoalDTO(goal: goalDTO) {
                    replyHandler(["sessionData": sessionData, "goalData": goalData])
                    print("iOS: Sent initial session and goal data to WatchOS.")
                } else {
                    print("iOS: ERROR encoding DTOs for initial data.")
                    replyHandler(["error": "Failed to encode initial data"])
                }
            } else {
                print("iOS: ERROR fetching initial session or goal data.")
                replyHandler(["error": "Failed to fetch initial data"])
            }
           
            
        case "sessionComplete": // --> mark session as complete
            if let sessionIDString = message["sessionID"] as? String,
               let dtoManager = self.dtoManager {
                
                // DTO manager func to mark session as complete
                dtoManager.markSessionAsCompleted(id: sessionIDString)
                
                // fetch sessions and goals
                if let updatedSessionModel = dtoManager.getSessionById(id: sessionIDString),
                   let currentGoalModel = dtoManager.getLatestGoal(){
                    
                    // convert to DTOs
                    if let updatedSessionDTO = dtoManager.sessionModelToDTO(model: updatedSessionModel),
                       let updatedGoalDTO = dtoManager.goalModelToDTO(model: currentGoalModel),
                       let updatedSessionData = dtoManager.encodeSessionDTO(session: updatedSessionDTO),
                       let updatedGoalData = dtoManager.encodeGoalDTO(goal: updatedGoalDTO) {
                        replyHandler([
                            "status": "success",
                            "updatedSessionData": updatedSessionData,
                            "updatedGoalData": updatedGoalData
                        ])
                    } else {
                        print("iOS: ERROR encoding updated DTOs for reply.")
                        replyHandler(["status": "failure", "reason": "Failed to encode updated data"])
                    }
                } else {
                    print("iOS: ERROR fetching updated session or goal for reply.")
                    replyHandler(["status": "failure", "reason": "Failed to fetch updated data for reply"])
                }
                return
            } else {
                print("iOS: ERROR: Missing sessionID or dependencies in sessionComplete message.")
                replyHandler(["status": "failure", "reason": "Missing data"])
            }
            return
            

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
