//
//  WatchSwifterWidget.swift
//  WatchSwifterWidget
//
//  Created by Adeline Charlotte Augustinne on 15/05/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
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
    let configuration: ConfigurationAppIntent
}

struct WatchSwifterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
//            Color("darkPrimary")
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Image("IconWatch")
                        Text("Next jog in")
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                    }
                    Text("7 days")
                        .fontWeight(.bold)
                        .font(.system(size: 17))
                    Text("Tue, 20 Aug 2025")
                        .fontWeight(.semibold)
                        .font(.system(size: 12))
                        .foregroundColor(Color("darkTealSubheading"))
                }
                Spacer()
                VStack {
                    renderProgressCircle()
                }
            }
//            .padding(.horizontal, 14)
        }
    }
    
    
    func renderProgressCircle() -> some View {
        
        let circleSize: Double = Double(43)
        let circleLineWidth: Double = Double(5)
        let progress = 2
        let targetFreq = 4
        
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
}

@main
struct WatchSwifterWidget: Widget {
    let kind: String = "WatchSwifterWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WatchSwifterWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
//                .cornerRadius(16)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 14.5)
//                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//                )
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    WatchSwifterWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
}
