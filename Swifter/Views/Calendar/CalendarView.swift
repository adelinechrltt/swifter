//
// CalendarView.swift
// Swifter
//
// Created by Teuku Fazariz Basya on 03/04/25.
//

import SwiftUI
import EventKit

struct Event: Identifiable {
    var id = UUID()
    var title: String
    var time: String
    var color: Color = .blue
}

struct CalendarView: View {
    // ViewModel to manage calendar data
    @StateObject private var viewModel = CalendarViewModel()
    
    // Initialize with the current date information
    @State private var selectedDate = Date()
    @State private var selectedDay: Int? = Calendar.current.component(.day, from: Date()) // Current day
    @State private var currentMonth = Calendar.current.component(.month, from: Date())
    @State private var currentYear = Calendar.current.component(.year, from: Date())
    @State private var showMonthPicker = false
    @State private var showYearPicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Month and year header
            HStack {
                // Month with picker
                Button(action: {
                    showMonthPicker = true
                }) {
                    Text("\(monthName(for: currentMonth))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showMonthPicker) {
                    VStack(spacing: 20) {
                        Text("Select Month")
                            .font(.headline)
                            .padding(.top)
                        
                        Picker("Month", selection: $currentMonth) {
                            ForEach(1...12, id: \.self) { month in
                                Text(monthName(for: month))
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Button("Done") {
                            showMonthPicker = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .presentationDetents([.height(250)])
                }
                
                Spacer()
                
                // Year with picker
                Button(action: {
                    showYearPicker = true
                }) {
                    Text(String(format: "%d", currentYear))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showYearPicker) {
                    VStack(spacing: 20) {
                        Text("Select Year")
                            .font(.headline)
                            .padding(.top)
                        
                        Picker("Year", selection: $currentYear) {
                            ForEach((currentYear-10)...(currentYear+10), id: \.self) { year in
                                Text(String(format: "%d", year))
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Button("Done") {
                            showYearPicker = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .presentationDetents([.height(250)])
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            // Calendar days
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20) {
                ForEach(daysInMonth(), id: \.self) { day in
                    if day > 0 {
                        DayView(day: day, isSelected: day == selectedDay, hasEvents: viewModel.hasEventsOnDay(day: day))
                            .onTapGesture {
                                selectedDay = day
                            }
                    } else {
                        // Empty space for days not in current month
                        Text("")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal)
            
            // Date display and edit button
            HStack {
                Text("\(weekdayName(for: dayOfWeek(year: currentYear, month: currentMonth, day: selectedDay ?? 1))), \(selectedDay ?? 1) \(monthNameShort(for: currentMonth)) \(String(format: "%d", currentYear))")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "pencil")
                    .foregroundColor(.gray)
            }
            .padding()
            .padding(.top)
            
            // Time slots display
            if viewModel.hasCalendarAccess {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<24) { hour in
                            let events = viewModel.fetchEventsForDay(year: currentYear, month: currentMonth, day: selectedDay ?? 1)
                            
                            HStack(alignment: .top) {
                                // Format the hour display with proper AM/PM
                                Text(formatHour(hour))
                                    .foregroundColor(.gray)
                                    .frame(width: 70, alignment: .leading)
                                
                                // Check if there's an event at this hour for the selected day
                                if let eventIndex = events.firstIndex(where: {
                                    // Match events based on hour part of time string
                                    let hourString = formatHourSimple(hour).lowercased()
                                    return $0.time.lowercased().contains(hourString)
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(events[eventIndex].title)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                        
                                        Text(events[eventIndex].time)
                                            .font(.caption)
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(events[eventIndex].color.opacity(0.3))
                                    )
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Spacer()
                                }
                            }
                            .frame(height: 60)
                            
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                VStack {
                    Text("Calendar Access Required")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    Text("Please grant calendar access in Settings to view your events")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    Button("Request Access") {
                        viewModel.checkCalendarAccess()
                    }
                    .padding(.top, 12)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
            
            // Bottom tab bar
            HStack {
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "calendar")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
        }
        .background(Color.white)
        .foregroundColor(.black)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        // Swipe right - go to previous month
                        if currentMonth > 1 {
                            currentMonth -= 1
                        } else {
                            currentMonth = 12
                            currentYear -= 1
                        }
                    } else if gesture.translation.width < -100 {
                        // Swipe left - go to next month
                        if currentMonth < 12 {
                            currentMonth += 1
                        } else {
                            currentMonth = 1
                            currentYear += 1
                        }
                    }
                }
        )
        .onAppear {
            // Fetch events when the view appears
            viewModel.fetchEventsForMonth(year: currentYear, month: currentMonth)
        }
        .onChange(of: currentMonth) { _, newMonth in
            // Refetch events when month changes
            viewModel.fetchEventsForMonth(year: currentYear, month: newMonth)
        }
        .onChange(of: currentYear) { _, newYear in
            // Refetch events when year changes
            viewModel.fetchEventsForMonth(year: newYear, month: currentMonth)
        }
    }
    
    // Helper methods
    private func daysInMonth() -> [Int] {
        var days = [Int]()
        
        // Get the first day of the month
        let firstDay = firstDayOfMonth(year: currentYear, month: currentMonth)
        
        // Add empty spaces for days of the previous month
        for _ in 0..<firstDay {
            days.append(0)
        }
        
        // Add days of the current month
        let numDays = numberOfDaysInMonth(year: currentYear, month: currentMonth)
        for day in 1...numDays {
            days.append(day)
        }
        
        return days
    }
    
    private func firstDayOfMonth(year: Int, month: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        let date = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: date) - 1 // Adjust because Sunday is 1 in Calendar but we want it to be 0
    }
    
    private func numberOfDaysInMonth(year: Int, month: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        
        let date = Calendar.current.date(from: components)!
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    private func dayOfWeek(year: Int, month: Int, day: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        let date = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: date)
    }
    
    private func monthName(for month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter.monthSymbols[month - 1]
    }
    
    private func monthNameShort(for month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter.shortMonthSymbols[month - 1]
    }
    
    private func weekdayName(for weekday: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter.weekdaySymbols[weekday - 1]
    }
    
    // Add two helper methods for formatting hours
    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
        
        // Check if the formatter uses AM/PM (12-hour format)
        let uses12HourFormat = formatter.dateFormat?.contains("a") ?? false
        
        if uses12HourFormat {
            if hour == 0 { return "12 AM" }
            if hour < 12 { return "\(hour) AM" }
            if hour == 12 { return "12 PM" }
            return "\(hour-12) PM"
        } else {
            return String(format: "%02d:00", hour)
        }
    }
    
    private func formatHourSimple(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
        
        // Check if the formatter uses AM/PM (12-hour format)
        let uses12HourFormat = formatter.dateFormat?.contains("a") ?? false
        
        if uses12HourFormat {
            if hour == 0 { return "12 AM" }
            if hour < 12 { return "\(hour) AM" }
            if hour == 12 { return "12 PM" }
            return "\(hour-12) PM"
        } else {
            return "\(hour):00"
        }
    }
}

struct DayView: View {
    let day: Int
    let isSelected: Bool
    let hasEvents: Bool
    
    var body: some View {
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 40)
            }
            
            Text("\(day)")
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .black : .black)
                .overlay(
                    hasEvents && !isSelected ?
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 6, height: 6)
                            .offset(y: 14)
                         : nil
                )
        }
        .frame(maxWidth: .infinity)
    }
}

// Preview
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .preferredColorScheme(.light)
    }
}

