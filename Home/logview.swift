
import SwiftUI

// MARK: - Log View
struct LogView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var selectedSpecies = "All"
    
    var filteredTrips: [Trip] {
        var trips = dataManager.trips.sorted(by: { $0.date > $1.date })
        
        if !searchText.isEmpty {
            trips = trips.filter { trip in
                trip.title.localizedCaseInsensitiveContains(searchText) ||
                trip.location.localizedCaseInsensitiveContains(searchText) ||
                trip.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if selectedSpecies != "All" {
            trips = trips.filter { $0.fishSpecies.contains(selectedSpecies) }
        }
        
        return trips
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.iceDarkBlue.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar at the top
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.iceTextSecondary)
                        
                        TextField("Search trips...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.iceCardBlue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                    
                    if filteredTrips.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 50, weight: .ultraLight))
                                .foregroundColor(.iceTextSecondary)
                                .opacity(0.5)
                            
                            Text(dataManager.trips.isEmpty ? "No trips logged yet" : "No results found")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredTrips) { trip in
                                    NavigationLink(destination:
                                        TripEditorView(existingTrip: trip)
                                            .navigationBarBackButtonHidden(true)
                                    ) {
                                        LogEntryCard(trip: trip)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Catch Log")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Log Entry Card
struct LogEntryCard: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(dateString)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.iceTextSecondary)
                        .tracking(0.3)
                    
                    Text(trip.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    if !trip.location.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 11))
                            Text(trip.location)
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.iceTextSecondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    HStack(spacing: 5) {
                        ForEach(1...5, id: \.self) { index in
                            Circle()
                                .fill(index <= trip.biteScore ? colorForBiteScore(trip.biteScore) : Color.iceDivider)
                                .frame(width: 7, height: 7)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Text("\(trip.catchCount)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "fish.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.iceSuccess)
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.iceCardBlue)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.iceDivider, lineWidth: 1)
        )
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: trip.date).uppercased()
    }
    
    func colorForBiteScore(_ score: Int) -> Color {
        switch score {
        case 4...5: return .iceSuccess
        case 2...3: return .iceAccent
        default: return .iceWarning
        }
    }
}
