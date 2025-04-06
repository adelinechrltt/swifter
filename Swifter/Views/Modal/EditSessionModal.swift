//
//  EditSession.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 27/03/25.
//

import Foundation
import SwiftUI

struct EditSessionModal: View {
    
    @EnvironmentObject private var eventStoreManager: EventStoreManager
    @StateObject private var viewModel: EditSessionViewModel
    
    @State private var showAlert = false
    @State private var showEventEditor = false
    @State private var errorText = ""
    @State private var showSaveAlert = false // 🔹 Added state for alert
    
    // init to inject environment object
    init() {
        let manager = EventStoreManager()
        _viewModel = StateObject(wrappedValue: EditSessionViewModel(eventStoreManager: manager))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Edit Session")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        showSaveAlert = true // 🔹 Trigger alert
                    } label: {
                        Text("Save")
                    }
                }
                
                DurationPicker(pickerLabel: "Pre-jog", startTime: $viewModel.startPrejog, endTime: $viewModel.endPrejog)
                DurationPicker(pickerLabel: "Jog", startTime: $viewModel.startJog, endTime: $viewModel.endJog)
                DurationPicker(pickerLabel: "Post-jog", startTime: $viewModel.startPostjog, endTime: $viewModel.endPostjog)
                
                Button {
//                    viewModel.eventStoreManager.findAvailableSlot(date: Date(), duration: 3600)
                } label: {
                    Text("Auto schedule")
                }
            }
            .padding()
            .alert("Save Session?", isPresented: $showSaveAlert) { // 🔹 Alert config
                Button("Cancel", role: .cancel) {}
                Button("OK") {
                    viewModel.createNewEvent(
                        eventTitle: "Jogging",
                        startTime: viewModel.startJog,
                        endTime: viewModel.endJog
                    )
                    showEventEditor = false
                }
            } message: {
                Text("Do you want to save the updated session?")
            }
        }
    }
}

#Preview {
    EditSessionModal().environmentObject(EventStoreManager())
}
