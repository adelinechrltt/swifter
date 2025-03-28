//
//  EditSessionViewModel.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 27/03/25.
//

//
//  CustomEventEditViewModel.swift
//  TestingEventKit
//
//  Created by Adeline Charlotte Augustinne on 27/03/25.
//

import Foundation
import SwiftUI
import EventKit

final class EditSessionViewModel: ObservableObject {
    
    // injected event store manager
    let eventStoreManager: EventStoreManager
    
    // pre-jog
    @Published var startPrejog: Date
    @Published var endPrejog: Date
    
    // jog
    @Published var startJog: Date
    @Published var endJog: Date
    
    // post-jog
    @Published var startPostjog: Date
    @Published var endPostjog: Date
    
    init(
        // set with initial values
        // biar gk meledak pas bikin instance of viewModel di view
        eventStoreManager: EventStoreManager,
        startPrejog: Date = Date(),
        endPrejog: Date = Date(),
        startJog: Date = Date(),
        endJog: Date = Date(),
        startPostjog: Date = Date(),
        endPostjog: Date = Date()
    ) {
        self.eventStoreManager = eventStoreManager
        self.startPrejog = startPrejog
        self.endPrejog = endPrejog
        self.startJog = startJog
        self.endJog = endJog
        self.startPostjog = startPostjog
        self.endPostjog = endPostjog
    }
    
    func createNewEvent(
        eventTitle: String,
        startTime: Date,
        endTime: Date
    ) {
        eventStoreManager.createNewEvent(eventTitle: eventTitle, startTime: startTime, endTime: endTime)
    }
}
