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
    @EnvironmentObject private var sessionManager: JoggingSessionManager
    @StateObject private var viewModel: EditSessionViewModel
    
    @State private var showSaveAlert = false
    @State private var showSuccess = false
    @Environment(\.dismiss) private var dismiss
    
    // The selected event to reschedule
    var selectedEvent: SessionModel?
    
    // init to inject environment object
    init(selectedEvent: SessionModel? = nil) {
        self.selectedEvent = selectedEvent
        // Create a temporary EventStoreManager that will be replaced in onAppear
        _viewModel = StateObject(wrappedValue: EditSessionViewModel(eventStoreManager: EventStoreManager()))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Text("Reschedule Session")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        showSaveAlert = true 
                    } label: {
                        Text("Save")
                            .fontWeight(.semibold)
                    }
                }
                
                // Show session info
                if let session = viewModel.selectedSession {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(session.sessionType.rawValue)
                            .font(.headline)
                        
                        Text("Current time: \(formatDate(session.startTime)) - \(formatDate(session.endTime))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if !viewModel.relatedSessions.isEmpty {
                            Text("Related sessions: \(viewModel.relatedSessions.count)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                
                // Date picker for new time
                VStack(alignment: .leading, spacing: 8) {
                    Text("New Start Time")
                        .font(.headline)
                    
                    DatePicker(
                        "Start Time",
                        selection: $viewModel.newStartTime,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .alert("Reschedule Session?", isPresented: $showSaveAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    // Use the environment eventStoreManager here
                    viewModel.eventStoreManager = eventStoreManager
                    
                    if viewModel.rescheduleSession(sessionManager: sessionManager) {
                        showSuccess = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    }
                }
            } message: {
                let count = 1 + viewModel.relatedSessions.count
                Text("This will reschedule \(count) session\(count > 1 ? "s" : "") to start at \(formatDate(viewModel.newStartTime)).")
            }
            .overlay {
                if showSuccess {
                    VStack {
                        Text("Session rescheduled!")
                            .font(.headline)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
                }
            }
        }
        .onAppear {
            // Replace the temporary EventStoreManager with the environment one
            viewModel.eventStoreManager = eventStoreManager
            
            if let event = selectedEvent {
                viewModel.loadSession(session: event, sessionManager: sessionManager)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}