import SwiftUI

struct UpcomingSession: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 6) {
                        Text("Upcoming Session")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.primary)
                        Text("Next jog session at:")
                            .font(.system(size: 15))
                            .foregroundColor(Color.secondary)
                    }
                    .padding(.vertical, 30)
                    
                    // Session Card (Now Wider)
                    VStack(spacing: 14) {
                        Text("Tomorrow")
                            .font(.system(size: 15))
                            .foregroundColor(Color.secondary)
                        
                        Text("Mon, 24 Mar")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(Color.primary)
                        Text("9AM - 10AM")
                            .font(.system(size: 16))
                            .foregroundColor(Color.secondary)
                        
                        HStack(spacing: 8) {
                            Text("Goal: Jog Twice in a week")
                                .font(.system(size: 14))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Color(.systemFill))
                                .cornerRadius(12)
                                .foregroundColor(Color.primary)
                            
                            Image(systemName: "pencil")
                                .font(.system(size: 16))
                                .foregroundColor(Color.primary)
                        }
                    }
                    .padding(18)
                    .frame(maxWidth: geometry.size.width * 0.9) // 🔥 Makes it Wider!
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                    .padding(.bottom, 28)
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Text("Reschedule")
                                .font(.system(size: 15, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color(.tertiarySystemFill))
                                .foregroundColor(Color.primary)
                                .cornerRadius(18)
                        }
                        
                        Button(action: {}) {
                            Text("Mark as Done")
                                .font(.system(size: 15, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.primary)
                                .foregroundColor(Color(.systemBackground))
                                .cornerRadius(18)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // Progress Circle
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 12)
                            .frame(width: 240, height: 240)
                        
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .stroke(Color.primary, lineWidth: 10)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 240, height: 240)
                        
                        
                        VStack(spacing: 8) {
                            Text("This Week")
                                .font(.system(size: 15))
                                .foregroundColor(Color.secondary)
                            
                            Text("1/2")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundColor(Color.primary)
                            
                            Text("Runs Completed")
                                .font(.system(size: 15))
                                .foregroundColor(Color.secondary)
                            
                            Button(action: {}) {
                                Text("See More")
                                    .font(.system(size: 12, weight: .medium))
                                    .padding(.horizontal, 26)
                                    .padding(.vertical, 10)
                                    .background(Color(.systemBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.primary, lineWidth: 1.5)
                                    )
                                    .foregroundColor(Color.primary)
                            }
                            .padding(.top, 12)
                        }
                    }
                    .frame(width: 240, height: 240)
                    .padding(.top, -20)
                    
                    Spacer()
                    
                    // Bottom Tab Bar
                    HStack {
                        Image(systemName: "figure.run")
                            .font(.system(size: 22))
                            .foregroundColor(Color.primary)
                        Spacer()
                        Image(systemName: "calendar")
                            .font(.system(size: 22))
                            .foregroundColor(Color.primary)
                    }
                    .padding(.horizontal, 70)
                    .padding(.vertical, 15)
                    .background(Color(.secondarySystemBackground))
                    .frame(width: geometry.size.width)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

#Preview {
    UpcomingSession()
}
