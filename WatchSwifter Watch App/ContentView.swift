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
    let dateFormatter = DateFormatter()
    
    // Computed properties based on receivedSession
        var nextStart: Date? {
            return watchToiOSConnector.receivedSession.startTime
        }

        var nextEnd: Date? {
            return watchToiOSConnector.receivedSession.endTime
        }

        var untilNextStart: DateComponents? {
            guard let nextStartDate = nextStart else { return nil }
            let now = Date()
            let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: nextStartDate)
            if let days = components.day, days >= 0 {
                return components
            }
            return nil
        }

        var daysUntilNextStart: Int {
            return untilNextStart?.day ?? 0
        }

        var hoursUntilNextStart: Int {
            return (untilNextStart?.hour ?? 0) % 24
        }

        var minutesUntilNextStart: Int {
            return (untilNextStart?.minute ?? 0) % 60
        }

        var jogDuration: Int {
            guard let start = nextStart, let end = nextEnd else {
                return 0
            }

            let durationInMinutes = end.timeIntervalSince(start) / 60

            if durationInMinutes < 0 {
                return 0
            }

            return Int(durationInMinutes)
        }
    
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
                        Text(isNow() ? "Now" : isToday() ? "\(hoursUntilNextStart)h \(minutesUntilNextStart)m" : "\(daysUntilNextStart) days")              .fontWeight(.bold)
                            .font(.system(size: 17))
                        Text(isNow() ? "\(jogDuration)-min run" : isToday() ? "\(formattedHours(nextStart ?? Date())) - \(formattedHours(nextEnd ?? Date()))" : "\(formattedDate(nextStart ?? Date()))")
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
                watchToiOSConnector.requestInitialDataFromiOS()
            }
            .padding(.vertical, 5)
            .buttonStyle(BorderedButtonStyle(tint: Color("darkTealButton").opacity(255)))
            .foregroundColor(.white)
            
        }
    }
    
    func renderProgressCircle() -> some View {
        
        let circleSize: Double = Double(43)
        let circleLineWidth: Double = Double(5)
        let progress = watchToiOSConnector.receivedGoal.progress
        let targetFreq = watchToiOSConnector.receivedGoal.targetFrequency
        
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
    
    func formattedDate(_ date: Date) -> String {
        dateFormatter.dateFormat = "E, dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func formattedHours(_ date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func isToday(for date: Date = Date()) -> Bool {
            let calendar = Calendar.current
        return calendar.isDate(watchToiOSConnector.receivedSession.startTime, inSameDayAs: date)
    }
    
    func isWithin3Hours(from date: Date = Date()) -> Bool {
        let timeDifference = watchToiOSConnector.receivedSession.startTime.timeIntervalSince(date)
        return timeDifference > 0 && timeDifference <= (3 * 60 * 60)
    }
    
    func isNow(for date: Date = Date()) -> Bool {
        let timeDifferenceStart = watchToiOSConnector.receivedSession.startTime.timeIntervalSince(date)
        let timeDifferenceEnd = watchToiOSConnector.receivedSession.endTime.timeIntervalSince(date)
        return timeDifferenceStart <= 0 && timeDifferenceEnd > 0
    }
}

#Preview {
    ContentView()
        .environmentObject(WatchToiOSConnector())
}
