//
//  WatchToiOSConnector.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 16/05/25.
//

import Foundation
import WatchConnectivity

class WatchToiOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    
    init(session: WCSession = .default){
        self.session = session
        super.init( )
        session.delegate = self
        session.activate()
    }
    
    /// initial check if session successfully activated or not
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }
    
    
    /// receive context data from iOS app
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
            print("WATCH: Received application context from iOS.")
            let decoder = JSONDecoder()
            
            var receivedSessionDTO: SessionDTO?
            var receivedGoalDTO: GoalDTO?

            if let sessionData = applicationContext["session"] as? Data {
                do {
                    receivedSessionDTO = try decoder.decode(SessionDTO.self, from: sessionData)
                    print("WATCH: Successfully decoded SessionDTO:")
                    print("WATCH:   Session ID (from DTO): \(receivedSessionDTO!.id)")
                    // ... (other prints)
                } catch {
                    print("WATCH: ERROR: Failed to decode SessionDTO: \(error.localizedDescription)")
                    // ... (data debug prints)
                }
            } else {
                print("WATCH: Session data not found or not Data type in received context.")
            }

            if let goalData = applicationContext["goal"] as? Data {
                do {
                    receivedGoalDTO = try decoder.decode(GoalDTO.self, from: goalData)
                    print("WATCH: Successfully decoded GoalDTO:")
                    print("WATCH:   Goal ID (from DTO): \(receivedGoalDTO!.id)")
                    // ... (other prints)
                } catch {
                    print("WATCH: ERROR: Failed to decode GoalDTO: \(error.localizedDescription)")
                    // ... (data debug prints)
                }
            } else {
                print("WATCH: Goal data not found or not Data type in received context.")
            }

            // --- Send the received DTOs back to iOS ---
            if let session = receivedSessionDTO, let goal = receivedGoalDTO {
                print("WATCH: Preparing to send DTOs back to iOS...")
                
                // Encode DTOs back to Data for sending
                let encoder = JSONEncoder()
                guard let sessionDataBack = try? encoder.encode(session),
                      let goalDataBack = try? encoder.encode(goal) else {
                    print("WATCH: ERROR: Failed to encode DTOs for sending back to iOS.")
                    return
                }

                let message: [String: Any] = [
                    "action": "roundtripData", // A new action to signify this test
                    "sessionData": sessionDataBack,
                    "goalData": goalDataBack
                ]

                guard WCSession.default.isReachable else {
                    print("WATCH: WCSession is NOT reachable. Cannot send data back to iOS.")
                    return
                }

                WCSession.default.sendMessage(message, replyHandler: { reply in
                    print("WATCH: Received reply from iOS for roundtripData: \(reply)")
                }) { error in
                    print("WATCH: ERROR: Failed to send roundtripData message to iOS: \(error.localizedDescription)")
                }
                print("WATCH: Sent roundtripData message to iOS.")
            } else {
                print("WATCH: One or both DTOs were nil, not sending back.")
            }
        }
        
    
}
