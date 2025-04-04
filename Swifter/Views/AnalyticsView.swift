//
//  Analytics.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 03/04/25.
//

import SwiftUI
import Charts

struct CardStyling<Content: View>: View {
    var content: Content
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2)))
    }
}

struct AnalyticsView: View {
    
    @Environment(\.modelContext) private var modelContext
    private var goalManager: GoalManager {
        GoalManager(modelContext: modelContext)
    }
    private var sessionManager: JoggingSessionManager {
        JoggingSessionManager(modelContext: modelContext)
    }
    
    @StateObject private var viewModel = AnalyticsViewModel()
    
    var donutChartData: [(category: String, value: Int)] {
        [
            ("Done", 1),
            ("Not done", 1)
        ]
    }
    
    var lineChartData: [(category: String, value: Int)] {
        [
            ("Completed goals", 3),
            ("Incomplete goals", 1)
        ]
    }
    
    @State var goalsDummy: [GoalModel] = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        return [
            GoalModel(targetFrequency: 10, startDate: formatter.date(from: "2025/01/01")!, endDate: formatter.date(from: "2025/03/01")!),
            GoalModel(targetFrequency: 15, startDate: formatter.date(from: "2025/02/20")!, endDate: formatter.date(from: "2025/05/20")!),
            GoalModel(targetFrequency: 20, startDate: formatter.date(from: "2025/03/01")!, endDate: formatter.date(from: "2025/06/01")!),
            GoalModel(targetFrequency: 30, startDate: formatter.date(from: "2025/01/01")!, endDate: formatter.date(from: "2025/07/01")!),
            GoalModel(targetFrequency: 25, startDate: formatter.date(from: "2025/02/15")!, endDate: formatter.date(from: "2025/04/15")!)
        ]
    }()

    var body: some View {
        ScrollView{
            HStack {
                Image(systemName: "chevron.backward")
                Text("My Stats")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            /// weekly progress card
            CardStyling(content:
                VStack(alignment: .leading){
                Text("Weekly Progress")
                    .font(.title2)
                    .fontWeight(.semibold)
                LazyVGrid(columns:
                            [GridItem(.flexible()),
                             GridItem(.flexible())
                            ])
                {
                    VStack{
                        Chart(viewModel.weeklyProgress, id: \.category) { item in
                            SectorMark(
                                angle: .value("Value", item.value),
                                innerRadius: .ratio(0.4)
                            )
                            .foregroundStyle(by: .value("Category", item.category))
                        }.chartLegend(.hidden)
                            .frame(idealWidth: 150, idealHeight: 150 )
                    }
                    VStack {
                        HStack{
                            if viewModel.weeklyProgress.count >= 2 {
                                Text("\(viewModel.weeklyProgress[0].value)/\(viewModel.weeklyProgress[0].value + viewModel.weeklyProgress[1].value)")
                                    .font(.title.bold())
                            } else {
                                Text("No weekly data")
                                    .font(.title3.italic())
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }.padding(.horizontal)
                        Text("runs completed this week").font(.title3).fontWeight(.regular)
                    }
                }
            }.padding(.horizontal, 15))
            
            /// monthly & all-time statistics
            HStack{
                CardStyling(content:
                VStack(alignment: .leading){
                    Text("Monthly")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack{
                        Text("\(viewModel.monthlyJogs)").font(.title.bold())
                        Text("total runs on March 2025").font(.caption)
                    }
                }.frame(maxWidth: .infinity))
                CardStyling(content:
                VStack(alignment: .leading){
                    Text("All-Time")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack{
                        Text("\(viewModel.totalJogs)").font(.title.bold())
                        Text("total runs completed with Swifter").font(.caption)
                    }.frame(maxWidth: 160)
                }.frame(maxWidth: .infinity))
            }
            
            /// goal statistics
            CardStyling(content: VStack(alignment: .leading){
                Text("Goal Statistics")
                    .font(.title2)
                    .fontWeight(.semibold)
                LazyVGrid(columns:
                            [GridItem(.flexible()),
                             GridItem(.flexible())
                            ])
                {
                    VStack {
                        HStack{
                            Text("\(viewModel.goalChartData[0].value)").font(.title3.bold())
                            Text((viewModel.goalChartData[0].value)>1 ? "completed goals" : "completed goal")
                        }
                        HStack{
                            if viewModel.weeklyProgress.count >= 2 {
                                Text("\(viewModel.goalChartData[1].value)")
                                Text((viewModel.goalChartData[1].value)>1 ? "completed goals" : "completed goal")
                            } else {
                                Text("Progress unavailable")
                            }
                        }
                    }
                    VStack{
                        Chart(viewModel.goalChartData, id: \.category) { item in
                            BarMark(
                                x: .value("Month", item.category),
                                y: .value("Value", item.value)
                            )
                        }.chartYAxis(.hidden)
                            .chartXAxis(.hidden)
                            .frame(maxHeight: 60)
                    }
                }
            }.padding(.horizontal, 15))
            
            /// my goals list
            CardStyling(content:
                VStack(alignment: .leading){
                    HStack{
                        Text("My Goals")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                HStack(){
                    Text("Freq")
                        .font(.caption).bold()
                        .frame(width: 70, alignment: .center)
                    Spacer()
                    Text("Status")
                        .font(.caption).bold()
                        .frame(width: 70, alignment: .center)
                    Spacer()
                    Text("Start")
                        .font(.caption).bold()
                        .frame(width: 80, alignment: .center)
                    Spacer()
                    Text("End")
                        .font(.caption).bold()
                        .frame(width: 80, alignment: .center)
                }
                .padding(.vertical, 5)
                .background(Color.gray.opacity(0.2))
                /// Scrollable Goal List
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.goals, id: \.self) { goal in
                            HStack {
                                Text("\(goal.targetFrequency)")
                                    .font(.caption)
                                    .frame(width: 70, alignment: .center)
                                Spacer()
                                Text("\(goal.status.rawValue)")
                                    .font(.caption)
                                    .foregroundStyle(goal.status == .completed ? .green : .primary)
                                    .frame(width: 70, alignment: .center)
                                Spacer()
                                Text(goal.startDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .frame(width: 80, alignment: .center)
                                Spacer()
                                Text(goal.endDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .frame(width: 80, alignment: .center)
                            }
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.3))
                            .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                        }
                    }
                }.frame(maxHeight: 200)
                    .clipped()
                    .gesture(DragGesture())
            }.padding(.horizontal, 15))
        }
        .padding()
        .onAppear(){
            viewModel.fetchGoalData(goalManager: goalManager)
            viewModel.fetchSessionData(sessionManager: sessionManager)
        }
    }
}

#Preview {
    AnalyticsView()
}
