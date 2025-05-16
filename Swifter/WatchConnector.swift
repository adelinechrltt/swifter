//
//  WatchConnector.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 16/05/25.
//

import Foundation
import WatchConnectivity

class WatchConnector: NSObject, WCSessionDelegate{
    var session: WCSession
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
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
    
    /// method for iOS app to respond to meesages from watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("Received message from watch: \(message)")
        
        guard let action = message["action"] as? String else {
            replyHandler(["status": "error", "reason": "No action specified"])
            return
        }

        switch action {
        case "markDone":
            if let sessionID = message["sessionID"] as? String {
                // Handle session completion logic here
                print("Marking session \(sessionID) as done")
                // Update database, calendar, etc.
                replyHandler(["status": "success"])
            } else {
                replyHandler(["status": "error", "reason": "No sessionID provided"])
            }
            
        case "reschedule":
            // Handle rescheduling logic here
            replyHandler(["status": "success", "newTime": "9:00AM"])
            
        default:
            replyHandler(["status": "error", "reason": "Unknown action"])
            
            
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
