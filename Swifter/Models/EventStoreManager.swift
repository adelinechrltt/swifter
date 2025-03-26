//
//  EventStoreManager.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 26/03/25.
//

import Foundation
import EventKit

class EventStoreManager: ObservableObject {
    let eventStore = EKEventStore()
}

// to be injected at root as environment variable
// kinda like global variable

// not instantialized multiple times in app
// because its expensive to init
