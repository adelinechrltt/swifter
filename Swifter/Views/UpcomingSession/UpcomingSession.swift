import SwiftUI

struct UpcomingSession: View {
    @State private var showButtons = false
    @State private var showProgress = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with Edit Preferences Button
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Edit Preferences tapped")
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 22))
                                .foregroundColor(Color.primary)
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 6) {
                        Text("Upcoming Session")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.primary)
                        Text("Next jog session at:")
                            .font(.system(size: 15))
                            .foregroundColor(Color.secondary)
                    }
                    .padding(.vertical, 30)

                    // Session Card
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

                            Button(action: {
                                print("Edit goal tapped")
                                //TODO: CHANGE TO OTHER PAGE

                            }) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.primary)
                            }
                        }
                    }
                    .padding(18)
                    .frame(maxWidth: geometry.size.width * 0.9)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                    .padding(.bottom, 28)

                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            print("Reschedule tapped")
                            //TODO: CHANGE TO OTHER PAGE
                        }) {
                            Text("Reschedule")
                                .font(.system(size: 15, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color(.tertiarySystemFill))
                                .foregroundColor(Color.primary)
                                .cornerRadius(18)
                        }

                        Button(action: {
                            print("Mark as Done tapped")
                            //TODO: CHANGE TO OTHER PAGE

                        }) {
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
                    .opacity(showButtons ? 1 : 0)
                    .offset(y: showButtons ? 0 : 40)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: showButtons)

                    Spacer()

                    // Progress Circle
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 12)
                            .frame(width: 240, height: 240)

                        Circle()
                            .trim(from: 0.0, to: showProgress ? 0.5 : 0.0)
                            .stroke(Color.primary, lineWidth: 10)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 240, height: 240)
                            .animation(.easeOut(duration: 1.0).delay(0.2), value: showProgress)

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

                            Button(action: {
                                print("See More tapped")
                                //TODO: CHANGE TO OTHER PAGE
 
                            }) {
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
                        Button(action: {
                            print("Run tab tapped")
                            //TODO: CHANGE TO OTHER PAGE
                        }) {
                            Image(systemName: "figure.run")
                                .font(.system(size: 22))
                                .foregroundColor(Color.primary)
                        }

                        Spacer()

                        Button(action: {
                            print("Calendar tab tapped")
                            //TODO: CHANGE TO OTHER PAGE
                        }) {
                            Image(systemName: "calendar")
                                .font(.system(size: 22))
                                .foregroundColor(Color.primary)
                        }
                    }
                    .padding(.horizontal, 70)
                    .padding(.vertical, 15)
                    .background(Color(.secondarySystemBackground))
                    .frame(width: geometry.size.width)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            showButtons = true
            showProgress = true
        }
    }
}

#Preview {
    UpcomingSession()
}
