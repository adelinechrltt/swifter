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
            // title
            HStack {
                Text("Swifter")
                    .foregroundColor(Color("tealTitle"))
                    .fontWeight(.medium)
                    .font(.system(size: 24))
                Spacer()
            }
            // card
            ZStack {
                RoundedRectangle(cornerRadius: 14.5)
                    .fill(Color("darkPrimary"))
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                HStack {
                    VStack(alignment: .leading){
                        Text("Your next jog is in")
                            .fontWeight(.medium)
                            .font(.system(size: 12))
                        Text("23 hours")
                            .fontWeight(.bold)
                            .font(.system(size: 17))
                        Text("13.00 - 13.30")
                            .font(.system(size: 12))
                            .foregroundColor(Color("tealHeading"))
                    }
                    Spacer()
                    VStack{
                        renderProgressCircle()
                    }
                }
                .padding(15)
            }
            Button("Ping iOS") {
                pingiOS()
            }
            .padding(.vertical, 5)
            .buttonStyle(BorderedButtonStyle(tint: Color("darkTealButton").opacity(255)))
            .foregroundColor(.white)

        }
    }

    func renderProgressCircle() -> some View {
        
        let circleSize: Double = Double(43)
        let circleLineWidth: Double = Double(5)
        let progress = 1
        let targetFreq = 2
        
        return
            ZStack {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: circleLineWidth)
                        .frame(width: circleSize, height: circleSize) .padding(.top, 10)
                    
                    Circle()
                        .trim(from: 0.0, to: Double(progress) / Double(targetFreq))
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, Color.green]),
                                startPoint: .leading,
                                endPoint: .trailing
                                
                            ),
                            style: StrokeStyle(
                                lineWidth: circleLineWidth,
                                lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: circleSize, height: circleSize)
                        .animation(.easeOut(duration: 1.0), value: 0.5)
                        .animation(.easeOut(duration: 1.0), value: 0.5)
                        .animation(.easeOut(duration: 1.0), value: 0.5)
                        .padding(.top, 10)
                }.padding(.bottom, 10)
                Text("\(progress)/\(targetFreq)")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            }.frame(width: circleSize, height: circleSize)
            .padding(.horizontal, 5)
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
