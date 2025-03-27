//
//  GoalModel.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 26/03/25.
//

import Foundation

@Observable
class GoalModel: Identifiable {
    let id = UUID()
    var targetFrequency: Int
    var startDate: Date
    var endDate: Date
    var progress: Int = 0
    enum isCompleted: String {
        case inProgress = "In progress"
        case completed = "Completed"
        case incomplete = "Incomplete"
    }
    
    init(targetFrequency: Int, startDate: Date, endDate: Date) {
        self.targetFrequency = targetFrequency
        self.startDate = startDate
        self.endDate = endDate
    }
}
