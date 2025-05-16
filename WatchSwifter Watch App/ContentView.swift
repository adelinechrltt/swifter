//
//  ContentView.swift
//  WatchSwifter Watch App
//
//  Created by Adeline Charlotte Augustinne on 15/05/25.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @EnvironmentObject var watchToiOSConnector: WatchToiOSConnector
    
    var body: some View {
            VStack {
                Text("Watch App")
                Button("Ping iOS") {
                    pingiOS()
                }
            }
        }

        func pingiOS() {
            guard WCSession.default.isReachable else {
                print("WATCH: WCSession is NOT reachable. iOS app might not be active or reachable.")
                return
            }
            
            let message = ["watch_ping": "Hello from Watch!"]
            
            WCSession.default.sendMessage(message, replyHandler: { reply in
                print("WATCH: Received reply from iOS for ping: \(reply)")
            }) { error in
                print("WATCH: Error sending ping message to iOS: \(error.localizedDescription)")
            }
            print("WATCH: Attempted to send ping message to iOS.")
        }
}

#Preview {
    ContentView()
}
