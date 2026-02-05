
import SwiftUI

// MARK: - Day Detail View
struct DayDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    let date: Date
    @State private var showingAddTrip = false
    
    var trips: [Trip] {
        dataManager.tripsForDate(date)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.iceDarkBlue.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Date header
                        VStack(spacing: 8) {
                            Image(systemName: "calendar.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.iceAccent)
                            
                            Text(dateString)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Trips (\(trips.count))")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.iceTextSecondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color.iceCardBlue)
                                .cornerRadius(20)
                        }
                        .padding(.top, 30)
                        
                        if trips.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "snowflake")
                                    .font(.system(size: 60, weight: .ultraLight))
                                    .foregroundColor(.iceTextSecondary)
                                    .opacity(0.4)
                                
                                Text("No trips yet")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.iceTextSecondary)
                                
                                Text("Add your first trip for this day")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.iceTextSecondary)
                                    .opacity(0.7)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 80)
                        } else {
                            ForEach(trips) { trip in
                                NavigationLink(destination:
                                    TripEditorView(existingTrip: trip)
                                        .navigationBarBackButtonHidden(true)
                                ) {
                                    TripCard(trip: trip)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                        Button(action: { showingAddTrip = true }) {
                            HStack(spacing: 10) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 22))
                                Text("Add trip for this day")
                                    .font(.system(size: 17, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.iceAccent, Color.iceAccent.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.iceAccent.opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.iceAccent)
                }
            }
            .sheet(isPresented: $showingAddTrip) {
                TripEditorView(date: date)
                    .environmentObject(dataManager)
            }
        }
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Trip Card
struct TripCard: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(trip.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    if !trip.location.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                            Text(trip.location)
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.iceTextSecondary)
                    }
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(colorForBiteScore(trip.biteScore).opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "figure.fishing")
                        .font(.system(size: 24))
                        .foregroundColor(colorForBiteScore(trip.biteScore))
                }
            }
            
            Rectangle()
                .fill(Color.iceDivider)
                .frame(height: 1)
            
            HStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("BITE SCORE")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.iceTextSecondary)
                        .tracking(0.5)
                    
                    HStack(spacing: 5) {
                        ForEach(1...5, id: \.self) { index in
                            Circle()
                                .fill(index <= trip.biteScore ? colorForBiteScore(trip.biteScore) : Color.iceDivider)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("CATCH")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.iceTextSecondary)
                        .tracking(0.5)
                    
                    HStack(spacing: 4) {
                        Text("\(trip.catchCount)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "fish.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.iceSuccess)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.iceCardBlue)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorForBiteScore(trip.biteScore).opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    func colorForBiteScore(_ score: Int) -> Color {
        switch score {
        case 4...5: return .iceSuccess
        case 2...3: return .iceAccent
        default: return .iceWarning
        }
    }
}
