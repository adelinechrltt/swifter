//
//  WatchSwifterWidget.swift
//  WatchSwifterWidget
//
//  Created by Adeline Charlotte Augustinne on 15/05/25.
//

import Foundation
import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let twoDaysInSeconds: TimeInterval = 2 * 60 * 60 * 24
        let thirtyMinutesInSeconds: TimeInterval = 30 * 60
        
        let nextStart = Date() + twoDaysInSeconds
        let nextEnd = Date() + twoDaysInSeconds + thirtyMinutesInSeconds
        
        return SimpleEntry(date: Date(),
                    nextStart: nextStart,
                    nextEnd: nextEnd,
                    progress: 2,
                    targetFreq: 3)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let twoDaysInSeconds: TimeInterval = 2 * 60 * 60 * 24
        let thirtyMinutesInSeconds: TimeInterval = 30 * 60
        
        let nextStart = Date() + twoDaysInSeconds
        let nextEnd = Date() + twoDaysInSeconds + thirtyMinutesInSeconds
        
        return SimpleEntry(date: Date(),
                    nextStart: nextStart,
                    nextEnd: nextEnd,
                    progress: 2,
                    targetFreq: 3)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        print("Widget timeline called.")

        
        var entries: [SimpleEntry] = []
            let defaults = UserDefaults(suiteName: "group.com.adeline.Swifter")

            let nextStart = defaults?.object(forKey: "nextStart") as? Date
            let nextEnd = defaults?.object(forKey: "nextEnd") as? Date
            let progress = defaults?.integer(forKey: "progress") ?? 0
            let targetFreq = defaults?.integer(forKey: "targetFreq") ?? 1

            let currentDate = Date()

            for halfHourOffset in 0..<24*2 {
                if let entryDate = Calendar.current.date(byAdding: .minute, value: halfHourOffset*30, to: currentDate) {
                    let entry = SimpleEntry(date: entryDate,
                                            nextStart: nextStart,
                                            nextEnd: nextEnd,
                                            progress: progress,
                                            targetFreq: targetFreq)
                    entries.append(entry)
                }
            }

        return Timeline(entries: entries, policy: .after(Date()))
    }
    
    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget")]
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let nextStart: Date?
    let nextEnd: Date?
    let progress: Int
    let targetFreq: Int
    
    // computed properties
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
}

struct WatchSwifterWidgetEntryView : View {
    var entry: Provider.Entry
    let dateFormatter = DateFormatter()

    var body: some View {
        ZStack {
            getBackgroundColor()
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Image("IconWatch")
                        Text("Next jog in")
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                    }
                    Text(isNow() ? "Now" : isToday() ? "\(entry.hoursUntilNextStart)h \(entry.minutesUntilNextStart)m" : "\(entry.daysUntilNextStart) days")
                        .fontWeight(.bold)
                        .font(.system(size: 17))
                        .foregroundColor(isWithin3Hours() ? isNow() ? Color("tealHeading") : Color("redHeading") : Color.white)
                    Text(isNow() ? "\(entry.jogDuration)-min run" : isToday() ? "\(formattedHours(entry.nextStart ?? Date())) - \(formattedHours(entry.nextEnd ?? Date()))" : "\(formattedDate(entry.nextStart ?? Date()))")
                        .fontWeight(.semibold)
                        .font(.system(size: 12))
                        .foregroundColor(isWithin3Hours() ? isNow() ? Color("tealSubheading") : Color("redSubheading") : Color("darkTealSubheading"))
                }
                Spacer()
                VStack {
                    renderProgressCircle()
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    func getBackgroundColor() -> LinearGradient? { 
        if entry.daysUntilNextStart < 1 {
            return LinearGradient(
                colors: [
                    Color("darkPrimary"),
                    Color("linearGrad1"),
                    Color("linearGrad2")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        }
        return nil
    }
    
    func renderProgressCircle() -> some View {
        
        let circleSize: Double = Double(43)
        let circleLineWidth: Double = Double(5)
        let progress = entry.progress
        let targetFreq = entry.targetFreq
        
        return
            ZStack {
//                Color.red
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
    
    func isToday() -> Bool {
        if(entry.daysUntilNextStart < 1) { return true }
        return false
    }
    
    func isWithin3Hours() -> Bool {
        if (entry.hoursUntilNextStart < 3 && entry.daysUntilNextStart < 1) { return true }
        return false
    }
    
    func isNow() -> Bool {
        if(entry.minutesUntilNextStart < 59 && entry.hoursUntilNextStart < 1 && entry.daysUntilNextStart < 1){
            return true
        }
        return false
    }
}

@main
struct WatchSwifterWidget: Widget {
    let kind: String = "WatchSwifterWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WatchSwifterWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
//                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 14.5)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
        }.contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
}


let nextStartPreview = Date()
let nextEndPreview = Date()+30*60

#Preview(as: .accessoryRectangular) {
    WatchSwifterWidget()
} timeline: {
    SimpleEntry(date: Date(),
        nextStart: nextStartPreview,
        nextEnd: nextEndPreview,
        progress: 2,
        targetFreq: 3)
}
