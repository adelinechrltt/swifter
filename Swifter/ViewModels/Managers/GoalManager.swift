//
//  GoalManager.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 29/03/25.
//

import SwiftData
import Foundation

class GoalManager: ObservableObject {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func createNewGoal(targetFreq: Int, startingDate: Date, endingDate: Date){
        let myGoal = GoalModel(targetFrequency: targetFreq, startDate: startingDate, endDate: endingDate)
        modelContext.insert(myGoal)
        
        do {
            try modelContext.save()
            print("✅ Preference saved successfully")
            print(fetchGoals())
        } catch {
            print("❌ Failed to save preferences: \(error)")
        }
    }
    
    func fetchGoals() -> GoalModel? {
        let goals = FetchDescriptor<GoalModel>()
        return try? modelContext.fetch(goals).first
    }
    
    func updateGoal(targetFreq: Int, startingDate: Date, endingDate: Date) {
        if let existingGoal = fetchGoals() {
            existingGoal.targetFrequency = targetFreq
            existingGoal.startDate = startingDate
            existingGoal.endDate = endingDate
            
            do {
                try modelContext.save()
                print("✅ Goal updated successfully")
                print("Target frequency: \(existingGoal.targetFrequency)")
                print("Start date: \(existingGoal.startDate)")
                print("End date: \(existingGoal.endDate)")
            } catch {
                print("❌ Failed to update goal: \(error)")
            }
        }
    }
}
