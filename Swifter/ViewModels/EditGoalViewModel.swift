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
        
         // Fetch the array of goals
         if let goals = goalManager.fetchGoals(), let firstGoal = goals.first {
             // Initialize with existing goal data if goals exist
             self.targetFrequency = firstGoal.targetFrequency
             self.startDate = firstGoal.startDate
             self.endDate = firstGoal.endDate
         } else {
             // Default values if no goal exists
             self.targetFrequency = 1
             self.startDate = Date()
             self.endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
         }
     }
    
     // Update existing goal or create new one if none exists
     func saveGoal() {
         // Fetch the goals again to check if any exist now
         if let goals = goalManager.fetchGoals(), !goals.isEmpty {
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
