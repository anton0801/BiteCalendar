
import SwiftUI

// MARK: - Stats View
struct StatsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingGoalEditor = false
    
    var currentMonthTrips: [Trip] {
        let calendar = Calendar.current
        let now = Date()
        return dataManager.trips.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .month)
        }
    }
    
    var averageBiteScore: Double {
        guard !currentMonthTrips.isEmpty else { return 0 }
        let sum = currentMonthTrips.reduce(0) { $0 + $1.biteScore }
        return Double(sum) / Double(currentMonthTrips.count)
    }
    
    var totalCatch: Int {
        currentMonthTrips.reduce(0) { $0 + $1.catchCount }
    }
    
    var bestDay: Trip? {
        currentMonthTrips.max(by: { $0.biteScore < $1.biteScore })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.iceDarkBlue.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Monthly overview
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("This Month")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: { showingGoalEditor = true }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "target")
                                            .font(.system(size: 14))
                                        Text("Goal")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .foregroundColor(.iceAccent)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.iceCardBlue)
                                    .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                StatCard(title: "Trips", value: "\(currentMonthTrips.count)", color: .iceAccent)
                                StatCard(title: "Total Catch", value: "\(totalCatch)", color: .iceSuccess)
                            }
                            
                            HStack(spacing: 16) {
                                StatCard(title: "Avg Bite", value: String(format: "%.1f", averageBiteScore), color: .iceWarning)
                                StatCard(title: "Goal", value: "\(currentMonthTrips.count)/\(dataManager.monthlyGoal)", color: .iceAccent)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Best day
                        if let best = bestDay {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Best Day")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(dateString(best.date))
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.iceAccent)
                                    
                                    Text(best.title)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    HStack {
                                        HStack(spacing: 4) {
                                            ForEach(1...5, id: \.self) { index in
                                                Circle()
                                                    .fill(index <= best.biteScore ? Color.iceSuccess : Color.iceDivider)
                                                    .frame(width: 8, height: 8)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(best.catchCount) fish")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding()
                                .background(Color.iceCardBlue)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                        
                        // Progress bar
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Monthly Goal Progress")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            VStack(spacing: 8) {
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Color.iceDivider)
                                            .frame(height: 8)
                                            .cornerRadius(4)
                                        
                                        Rectangle()
                                            .fill(Color.iceAccent)
                                            .frame(width: geometry.size.width * min(CGFloat(currentMonthTrips.count) / CGFloat(dataManager.monthlyGoal), 1.0), height: 8)
                                            .cornerRadius(4)
                                    }
                                }
                                .frame(height: 8)
                                
                                Text("\(currentMonthTrips.count) of \(dataManager.monthlyGoal) trips completed")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.iceCardBlue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingGoalEditor) {
                GoalEditorView(monthlyGoal: .constant("\(dataManager.monthlyGoal)"))
                    .environmentObject(dataManager)
            }
        }
    }
    
    func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.iceTextSecondary)
                .tracking(0.5)
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.iceCardBlue)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}
