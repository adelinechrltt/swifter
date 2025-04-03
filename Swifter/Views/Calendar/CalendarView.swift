//
// CalendarView.swift
// Swifter
//
// Created by Teuku Fazariz Basya on 03/04/25.
//

import SwiftUI

struct Event: Identifiable {
    var id = UUID()
    var title: String
    var time: String
    var color: Color = .blue
}

struct CalendarView: View {
    // Initialize with the current date information
    @State private var selectedDate = Date()
    @State private var selectedDay: Int? = Calendar.current.component(.day, from: Date()) // Current day
    @State private var currentMonth = Calendar.current.component(.month, from: Date())
    @State private var currentYear = Calendar.current.component(.year, from: Date())
    
    // Sample events
    @State private var events: [Int: [Event]] = [
        24: [
            Event(title: "Team Meeting", time: "10:00 AM", color: .blue),
            Event(title: "Lunch with Alex", time: "12:30 PM", color: .green),
            Event(title: "Project Deadline", time: "5:00 PM", color: .red)
        ],
        26: [
            Event(title: "Doctor Appointment", time: "9:00 AM", color: .purple),
            Event(title: "Gym Session", time: "6:30 PM", color: .orange)
        ]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Month and year header
            HStack {
                Text("\(monthName(for: currentMonth))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(String(format: "%d", currentYear)) 
                    .font(.largeTitle)
                    .fontWeight(.bold)
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
                        DayView(day: day, isSelected: day == selectedDay, hasEvents: events[day] != nil)
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
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<24) { hour in
                        HStack(alignment: .top) {
                            // Format the hour display with proper AM/PM
                            Text(formatHour(hour))
                                .foregroundColor(.gray)
                                .frame(width: 70, alignment: .leading)
                            
                            // Check if there's an event at this hour for the selected day
                            if let dayEvents = events[selectedDay ?? 0],
                               let eventIndex = dayEvents.firstIndex(where: {
                                   // This is a simplified check - in a real app you'd parse the time string
                                   $0.time.contains("\(formatHourSimple(hour))")
                               }) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(dayEvents[eventIndex].color.opacity(0.3))
                                    .frame(height: 30)
                                    .padding(.leading, 8)
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
            
            Spacer()
            
            // Bottom tab bar
            HStack {
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "calendar")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.black)
        }
        .background(Color.black)
        .foregroundColor(.white)
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
                .foregroundColor(isSelected ? .white : .white)
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
            .preferredColorScheme(.dark)
    }
}

