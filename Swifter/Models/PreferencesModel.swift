//
//  PreferencesModel.swift
//  Swifter
//
//  Created by Teuku Fazariz Basya on 26/03/25.
//

import Foundation
import SwiftData

enum TimeOfDay: String, CaseIterable, Identifiable, Codable{
    case morning = "Morning"
    case noon = "Noon"
    case afternoon = "Afternoon"
    case evening = "Evening"
    
    var id: String { self.rawValue }
}

enum DayOfWeek: Int, CaseIterable, Identifiable, Codable{
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1

    var id: Int { self.rawValue }

    var name: String {
        switch self {
        case .monday : return "Monday"
        case .tuesday : return "Tuesday"
        case .wednesday : return "Wednesday"
        case .thursday : return "Thursday"
        case .friday : return "Friday"
        case .saturday : return "Saturday"
        case .sunday : return "Sunday"
        }
    }
}

@Model
class PreferencesModel {
    var preJogDuration: Int
    var postJogDuration: Int
    
    var preferredTimesOfDay: [TimeOfDay]
    var preferredDaysOfWeek: [DayOfWeek]
    
    init(timeOfDay: [TimeOfDay], dayOfWeek: [DayOfWeek], preJogDuration: Int, postJogDuration: Int) {
        self.preferredTimesOfDay = Array(Set(timeOfDay))
        self.preferredDaysOfWeek = Array(Set(dayOfWeek))
        self.preJogDuration = preJogDuration
        self.postJogDuration = postJogDuration
    }
}
