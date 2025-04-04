//
//  AnalyticsViewModel.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 04/04/25.
//

import Foundation
import SwiftUI

final class AnalyticsViewModel: ObservableObject {
    
    @Published var weeklyProgress: [(category: String, value: Int)]
    @Published var goals: [GoalModel]
    @Published var goalChartData: [(category: String, value: Int)]
    @Published var monthlyJogs: Int
    @Published var totalJogs: Int
    
    init(){
        weeklyProgress = []
        goals = []
        goalChartData = [(category: "", value: 0)]
        monthlyJogs = 0
        totalJogs = 0
    }
    
    func fetchGoalData(goalManager: GoalManager){
        if let goalTemp = goalManager.fetchGoals() {
            self.goals = goalTemp
        } else {
            
            /// default values for troubleshooting
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"

            goals = [
                GoalModel(targetFrequency: 10, startDate: formatter.date(from: "2025/01/01")!, endDate: formatter.date(from: "2025/03/01")!),
                     GoalModel(targetFrequency: 15, startDate: formatter.date(from: "2025/02/20")!, endDate: formatter.date(from: "2025/05/20")!),
                     GoalModel(targetFrequency: 20, startDate: formatter.date(from: "2025/03/01")!, endDate: formatter.date(from: "2025/06/01")!),
                     GoalModel(targetFrequency: 30, startDate: formatter.date(from: "2025/01/01")!, endDate: formatter.date(from: "2025/07/01")!),
                     GoalModel(targetFrequency: 25, startDate: formatter.date(from: "2025/02/15")!, endDate: formatter.date(from: "2025/04/15")!)
            ]
        }
        
        self.weeklyProgress = [(category: "Completed", value: goals.sorted { $0.startDate < $1.startDate }.first!.progress),
                          (category: "Incomplete", value: goals.sorted { $0.startDate < $1.startDate }.first!.targetFrequency - goals.sorted { $0.startDate < $1.startDate }.first!.progress)]
        
        self.goalChartData = [(category: "Completed goals", value: goals.filter { $0.status == GoalStatus.completed}.count),
        (category: "Incomplete goals", value: goals.filter { $0.status == GoalStatus.incomplete}.count)]
    }
    
    func fetchSessionData(sessionManager: JoggingSessionManager){
        let calendar = Calendar.current
        self.monthlyJogs = sessionManager.fetchAllSessions().filter{
            calendar.isDate($0.startTime, equalTo: Date(), toGranularity: .month) && $0.status == isCompleted.completed
        }.count
        
        self.totalJogs = sessionManager.fetchAllSessions().filter{
            $0.status == isCompleted.completed
        }.count
    }
    
}
