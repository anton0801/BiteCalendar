
import SwiftUI

// MARK: - Calendar View
struct CalendarView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var showingAddTrip = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.iceDarkBlue.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom header with month/year
                    HStack {
                        Button(action: { changeMonth(by: -1) }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .foregroundColor(.iceAccent)
                                .font(.system(size: 32))
                        }
                        
                        Spacer()
                        
                        Text(monthYearString)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { changeMonth(by: 1) }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .foregroundColor(.iceAccent)
                                .font(.system(size: 32))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    
                    // Weekday headers
                    HStack(spacing: 0) {
                        ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                            Text(day)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.iceTextSecondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    
                    // Calendar grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                        ForEach(daysInMonth, id: \.self) { date in
                            if let date = date {
                                DayCell(date: date, isSelected: isSelected(date), trips: dataManager.tripsForDate(date))
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedDate = date
                                        }
                                    }
                            } else {
                                Color.clear
                                    .frame(height: 60)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Add trip button
                    Button(action: { showingAddTrip = true }) {
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 22))
                            Text("Add Trip")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.iceAccent)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: Binding(
                get: { selectedDate != nil },
                set: { if !$0 { selectedDate = nil } }
            )) {
                if let date = selectedDate {
                    DayDetailView(date: date)
                        .environmentObject(dataManager)
                }
            }
            .sheet(isPresented: $showingAddTrip) {
                TripEditorView(date: Date())
                    .environmentObject(dataManager)
            }
        }
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    func changeMonth(by value: Int) {
        withAnimation {
            if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
                currentDate = newDate
            }
        }
    }
    
    var daysInMonth: [Date?] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: currentDate),
              let firstDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate)) else {
            return []
        }
        
        let firstWeekday = Calendar.current.component(.weekday, from: firstDay)
        let offset = (firstWeekday + 5) % 7
        
        var days: [Date?] = Array(repeating: nil, count: offset)
        
        for day in range {
            if let date = Calendar.current.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        return days
    }
    
    func isSelected(_ date: Date) -> Bool {
        guard let selectedDate = selectedDate else { return false }
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
}

// MARK: - Day Cell
struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let trips: [Trip]
    
    var body: some View {
        VStack(spacing: 6) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 20, weight: isToday ? .bold : .medium))
                .foregroundColor(.white)
            
            if !trips.isEmpty {
                HStack(spacing: 3) {
                    ForEach(trips.prefix(3)) { trip in
                        Circle()
                            .fill(colorForBiteScore(trip.biteScore))
                            .frame(width: 6, height: 6)
                    }
                }
            } else {
                Spacer()
                    .frame(height: 6)
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.iceCardBlue : (isToday ? Color.iceCardBlue.opacity(0.5) : Color.clear))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isToday ? Color.iceAccent : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func colorForBiteScore(_ score: Int) -> Color {
        switch score {
        case 4...5: return .iceSuccess
        case 2...3: return .iceAccent
        default: return .iceWarning
        }
    }
}
