//
//  EditSession.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 27/03/25.
//

import Foundation
import SwiftUI

struct EditSessionView: View {
    
    @EnvironmentObject private var eventStoreManager: EventStoreManager
    @StateObject private var viewModel: EditSessionViewModel
    
    @State private var showAlert = false
    @State private var showEventEditor = false
    @State private var errorText = ""
    
    // init to inject environment object
    init() {
        let manager = EventStoreManager()
        _viewModel = StateObject(wrappedValue: EditSessionViewModel(eventStoreManager: manager))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                    HStack{
                        Text("Edit Session")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            viewModel.createNewEvent(
                                eventTitle: "Jogging",
                                startTime: viewModel.startJog,
                                endTime: viewModel.endJog
                            )
                            showEventEditor = false
                        } label: {
                            Text("Save")
                        }
                    }
                    
                    DurationPicker(pickerLabel: "Pre-jog", startTime: $viewModel.startPrejog, endTime: $viewModel.endPrejog)
                    DurationPicker(pickerLabel: "Jog", startTime: $viewModel.startJog, endTime: $viewModel.endJog)
                    DurationPicker(pickerLabel: "Post-jog", startTime: $viewModel.startPostjog, endTime: $viewModel.endPostjog)
                    
                    Button {
                        viewModel.eventStoreManager.findAvailableSlot(date: Date(), duration: 3600)
                    } label: {
                        Text("Auto schedule")
                    }
                }
            }.padding()
        }
    }

#Preview {
    EditSessionView().environmentObject(EventStoreManager())
}
