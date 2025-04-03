//
//  EditGoalViewModel.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 26/03/25.
//

import Foundation
import SwiftUI
import SwiftData

final class EditGoalViewModel: ObservableObject {
    private let goalManager: GoalManager
    
    @Published var targetFrequency: Int
    @Published var startDate: Date
    @Published var endDate: Date
    
    init(goalManager: GoalManager) {
        self.goalManager = goalManager
        
        // Initialize with existing goal data if available
        if let existingGoal = goalManager.fetchGoals() {
            self.targetFrequency = existingGoal.targetFrequency
            self.startDate = existingGoal.startDate
            self.endDate = existingGoal.endDate
        } else {
            // Default values if no goal exists
            self.targetFrequency = 1
            self.startDate = Date()
            self.endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        }
    }
    
    // Update existing goal or create new one if none exists
    func saveGoal() {
        //ambil goal kalau ada
        if goalManager.fetchGoals() != nil {
            goalManager.updateGoal(
                targetFreq: targetFrequency,
                startingDate: startDate,
                endingDate: endDate
            )
        } else {
            goalManager.createNewGoal(
                targetFreq: targetFrequency,
                startingDate: startDate,
                endingDate: endDate
            )
        }
    }
}
