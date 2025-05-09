//
//  SwifterWidget.swift
//  SwifterWidget
//
//  Created by Adeline Charlotte Augustinne on 09/05/25.
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
        
        // variables:
        // 1) days
        // 2) hours
        // 3) minutes
        // 4) date
        // 5) progress
        // 1-4 computed properties

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct SwifterWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    var colors: [Color] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
//                TODO: add logic for conditionally appending colors in the color array based on the duration to the next jog :D
                colors: [Color("darkPrimary"), Color("darkTeal")/*, Color("midTeal")*/],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            switch family {
            case .systemSmall:
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
                        Text("7 days")
                            .fontWeight(.bold)
                            .font(.system(size: 38))
                        Text("14h 30m")
                            .fontWeight(.bold)
                            .font(.system(size: 17))
                            .foregroundColor(Color("darkTealSubheading"))
                    }
                    Spacer()
                    Text("Tue, 20 Aug 2025")
                        .fontWeight(.medium)
                        .font(.system(size: 11))
                }.padding(16)
            case .systemMedium:
                Text("Medium")
            case .systemLarge:
                Text("Large")
            default:
                Text("this is the default idk what to put here")
            }
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

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
}

#Preview(as: .systemSmall) {
    SwifterWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
}

#Preview(as: .systemMedium) {
    SwifterWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
}
