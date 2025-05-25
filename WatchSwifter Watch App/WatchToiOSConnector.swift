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
    @Published var receivedSession: SessionDTO? = nil
    @Published var receivedGoal: GoalDTO? = nil
    @Published var isiOSReachable: Bool = false
    
    let decoder: JSONDecoder = JSONDecoder()
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    /// initial check if session successfully activated or not
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("WATCH: WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WATCH: WCSession activated with state: \(activationState.rawValue)")
        DispatchQueue.main.async {
            self.isiOSReachable = session.isReachable
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isiOSReachable = session.isReachable
            print("WATCH: iOS Reachability changed: \(self.isiOSReachable)")
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile, metadata: [String : Any]) {
        print("WATCH: Received file: \(file), metadata: \(metadata)")
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("WATCH: Received user info: \(userInfo)")
    }
    
    func getSession() -> SessionDTO {
        let sampleSessionDTO = SessionDTO(
            id: UUID().uuidString,
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            calendarEventId: "calEvent123",
            sessionType: SessionType.jogging.rawValue,
            status: isCompleted.incomplete.rawValue
        )
        
        guard let receivedSession = self.receivedSession else {
            print("WATCH: Returning sample session DTO")
            return sampleSessionDTO
        }
        
        return receivedSession
    }
    
    func getGoal() -> GoalDTO {
        let sampleGoalDTO = GoalDTO(
            id: UUID().uuidString,
            targetFrequency: 3,
            startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            endDate: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
            progress: 1,
            status: GoalStatus.inProgress.rawValue
        )
        
        guard let receivedGoal = self.receivedGoal else {
            print("WATCH: Returning sample goal DTO")
            return sampleGoalDTO
        }
        
        return receivedGoal
    }
    
    func decodeData(sessionData: Data, goalData: Data) {
        if let sessionDTO = try? decoder.decode(SessionDTO.self, from: sessionData),
           let goalDTO = try? decoder.decode(GoalDTO.self, from: goalData) {
            DispatchQueue.main.async {
                self.receivedSession = sessionDTO
                self.receivedGoal = goalDTO
                print("WATCH: Received and decoded initial data from iOS.")
                print("WATCH: Initial Session ID: \(sessionDTO.id)")
                print("WATCH: Initial Goal ID: \(goalDTO.id)")
            }
        } else {
            print("WATCH: ERROR decoding initial data from iOS.")
        }
    }
}

// MARK: request data from iOS
extension WatchToiOSConnector {
    func requestInitialDataFromiOS() {
        guard WCSession.default.isReachable else {
            print("WATCH: iOS app is not reachable. Cannot request initial data.")
            return
        }
        
        WCSession.default.sendMessage(["action": "requestInitialData"], replyHandler: { reply in
            // handle data received from iOS in the reply
            if let sessionData = reply["sessionData"] as? Data,
               let goalData = reply["goalData"] as? Data {
                // decode data
                self.decodeData(sessionData: sessionData, goalData: goalData)
            } else if let error = reply["error"] as? String {
                print("WATCH: ERROR receiving initial data from iOS: \(error)")
            }
        }) { error in
            print("WATCH: ERROR sending initial data request to iOS: \(error.localizedDescription)")
        }
    }
}

// MARK: receive data from iOS
extension WatchToiOSConnector {
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("WATCH: Received application context from iOS.")
        let decoder = JSONDecoder()

        if let sessionData = applicationContext["session"] as? Data,
           let sessionDTO = try? decoder.decode(SessionDTO.self, from: sessionData) {
            DispatchQueue.main.async {
                self.receivedSession = sessionDTO
                print("WATCH: Received SessionDTO via context: \(sessionDTO.id)")
            }
        } else {
            print("WATCH: Session data not found or error decoding in context.")
        }

        if let goalData = applicationContext["goal"] as? Data,
           let goalDTO = try? decoder.decode(GoalDTO.self, from: goalData) {
            DispatchQueue.main.async {
                self.receivedGoal = goalDTO
                print("WATCH: Received GoalDTO via context: \(goalDTO.id)")
            }
        } else {
            print("WATCH: Goal data not found or error decoding in context.")
        }
    }
}

// MARK: mark session as done, send back to iOS
extension WatchToiOSConnector {
    func sendSessionCompletedUpdateToiOS(sessionDTO: SessionDTO) {
        guard WCSession.default.isReachable else {
            print("WATCH: iOS app is not reachable. Cannot send session completed update.")
            return
        }

        let message: [String: Any] = [
            "action": "sessionComplete",
            "sessionID": sessionDTO.id
        ]

        WCSession.default.sendMessage(message, replyHandler: { reply in
            if let status = reply["status"] as? String {
                print("WATCH: Received reply for markSessionCompleteAndReturnData: \(status)")
                
                if status == "success",
                   let updatedSessionData = reply["updatedSessionData"] as? Data,
                   let updatedGoalData = reply["updatedGoalData"] as? Data {
                    
                    self.decodeData(sessionData: updatedSessionData, goalData: updatedGoalData)
                    
                } else if let reason = reply["reason"] as? String {
                    print("WATCH: iOS failed to mark session \(sessionDTO.id) as complete: \(reason)")
                }
            } else {
                print("WATCH: Received unexpected reply format for markSessionCompleteAndReturnData.")
            }
        }) { error in
            print("WATCH: ERROR sending markSessionCompleteAndReturnData message to iOS: \(error.localizedDescription)")
        }
        print("WATCH: Sent request to mark session \(sessionDTO.id) as complete and return updated data to iOS.")
    }
}
