//
//  GoalModel.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 26/03/25.
//

import Foundation

class GoalModel: Identifiable {
    let id = UUID()
    var targetFrequency: Int
    var startDate : Date
    var endDate : Date
    
    init(targetFrequency: Int!, startDate: Date!, endDate: Date!) {
        self.targetFrequency = targetFrequency
        self.startDate = startDate
        self.endDate = endDate
    }
}
