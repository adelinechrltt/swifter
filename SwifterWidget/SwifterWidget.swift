//
//  SwifterWidget.swift
//  SwifterWidget
//
//  Created by Adeline Charlotte Augustinne on 09/05/25.
//

import Foundation
import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    nextStart: Date()+2*60*60*24,
                    nextEnd: Date()+2*60*60*24+30*60,
                    progress: 2,
                    targetFreq: 3)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(),
                    nextStart: Date()+2*60*60*24,
                    nextEnd: Date()+2*60*60*24+30*60,
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

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    // variables:
    // 1) days
    // 2) hours
    // 3) minutes
    // 4) date
    // 5) progress
    // 1-4 computed properties
    
    let date: Date
    let nextStart: Date?
    let nextEnd: Date?
    let progress: Int
    let targetFreq: Int
        
    // computed properties
    var untilNextStart: DateComponents? {
        guard let nextStartDate = nextStart else {
            return nil
        }

        let calendar = Calendar.current
        let today = Date()

        let startOfToday = calendar.startOfDay(for: today)
        let startOfNextDay = calendar.startOfDay(for: nextStartDate)

        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfNextDay)
        return components
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
    
}

struct SwifterWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color("darkPrimary"),
                         Color("darkTeal"), Color("midTeal")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            switch family {
            case .systemSmall:
                renderNextJog().padding(16)
            case .systemMedium:
                HStack {
                    renderNextJog()
                    renderProgressCircle()
                }.padding(25)
            case .systemLarge:
                Text("Large")
            default:
                Text("this is the default idk what to put here")
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        dateFormatter.dateFormat = "E, dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    // TODO: add logic for conditionally appending colors in the color array based on the duration to the next jog :D
    func getBackgroundGradient() -> [Color]{
        return []
    }
    
    func renderNextJog() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(spacing: 6) {
                    Image("JogLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 15)
                    Text("Next jog in")
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                    Spacer()
                }
                Text("\(entry.daysUntilNextStart) days")
                    .fontWeight(.bold)
                    .font(.system(size: 38))
                Text("\(entry.hoursUntilNextStart)h \(entry.minutesUntilNextStart)m")
                    .fontWeight(.bold)
                    .font(.system(size: 17))
                    .foregroundColor(Color("darkTealSubheading"))
            }
            Spacer()
            Text("\(formattedDate(entry.nextStart ?? Date()))")
                .fontWeight(.medium)
                .font(.system(size: 11))
        }
    }
    
    func renderProgressCircle() -> some View {
        ZStack {
            ZStack {
                Color.clear
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 16)
                    .frame(width: 100, height: 100) .padding(.top, 10)
                
                Circle()
                    .trim(from: 0.0, to: Double(entry.progress) / Double(entry.targetFreq))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, Color.green]),
                            startPoint: .leading,
                            endPoint: .trailing
                            
                        ),
                        lineWidth: 16
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100, height: 100)
                    .animation(.easeOut(duration: 1.0), value: 0.5)
                    .animation(.easeOut(duration: 1.0), value: 0.5)
                    .animation(.easeOut(duration: 1.0), value: 0.5)
                    .padding(.top, 10)
            }.padding(.bottom, 10)
            Text("\(entry.progress)/\(entry.targetFreq)")
                .font(.system(size: 24))
                .fontWeight(.bold)
        }
    }
    
}

struct SwifterWidget: Widget {
    let kind: String = "SwifterWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            SwifterWidgetEntryView(entry: entry)
                .containerBackground(Color.darkTeal, for: .widget)
                
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    SwifterWidget()
} timeline: {
    SimpleEntry(date: Date(),
                nextStart: Date()+2*60*60*24,
                nextEnd: Date()+2*60*60*24+30*60,
                progress: 2,
                targetFreq: 3)}

#Preview(as: .systemMedium) {
    SwifterWidget()
} timeline: {
    SimpleEntry(date: Date(),
                nextStart: Date()+2*60*60*24,
                nextEnd: Date()+2*60*60*24+30*60,
                progress: 3,
                targetFreq: 4)
}
