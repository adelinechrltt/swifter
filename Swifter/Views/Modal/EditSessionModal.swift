//
//  EditSession.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 27/03/25.
//

import Foundation
import SwiftUI

struct EditSessionModal: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject private var eventStoreManager: EventStoreManager
    @StateObject private var viewModel: EditSessionViewModel
    
    @State private var showSaveAlert = false
    
    // Init with optional session parameter
    init(session: SessionModel? = nil) {
        _viewModel = StateObject(wrappedValue: EditSessionViewModel(
            session: session
        ))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Session title
                Text(viewModel.sessionTitle)
                    .font(.headline)
                    .padding(.top)
                
                // Single time picker for session start/end
                VStack(alignment: .leading, spacing: 16) {
                    Text("Session Time")
                        .font(.headline)
                    
                    VStack(alignment: .leading) {
                        DatePicker("Start", selection: $viewModel.startTime)
                            .datePickerStyle(.compact)
                            .padding(.bottom, 8)
                        
                        DatePicker("End", selection: $viewModel.endTime)
                            .datePickerStyle(.compact)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Duration display
                let duration = viewModel.endTime.timeIntervalSince(viewModel.startTime)
                Text("Duration: \(formattedDuration(seconds: duration))")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        showSaveAlert = true
                    }
                }
            }
            .alert("Save Changes", isPresented: $showSaveAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    if viewModel.currentSession != nil {
                        // Update existing session
                        if viewModel.saveSessionChanges() {
                            dismiss()
                        }
                    } else {
                        // Create new session
                        if viewModel.createNewEvent() != nil {
                            dismiss()
                        }
                    }
                }
            } message: {
                Text("Do you want to save these changes to your session?")
            }
            .onAppear {
                viewModel.eventStoreManager = eventStoreManager
                viewModel.sessionManager = JoggingSessionManager(modelContext: modelContext)
            }
        }
    }
    
    private func formattedDuration(seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else {
            return "\(minutes) minutes"
        }
    }
}

#Preview {
    EditSessionModal()
        .environmentObject(EventStoreManager())
}
