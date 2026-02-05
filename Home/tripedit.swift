
import SwiftUI

// MARK: - Trip Editor View
struct TripEditorView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    
    let date: Date
    @State private var trip: Trip
    @State private var isNewTrip: Bool
    
    init(date: Date = Date(), existingTrip: Trip? = nil) {
        self.date = date
        if let existing = existingTrip {
            _trip = State(initialValue: existing)
            _isNewTrip = State(initialValue: false)
        } else {
            _trip = State(initialValue: Trip(
                date: date,
                title: "",
                location: "",
                notes: "",
                biteScore: 3,
                catchCount: 0,
                fishSpecies: [],
                wind: .low,
                cloud: .normal
            ))
            _isNewTrip = State(initialValue: true)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.iceDarkBlue.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Basic Info
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.iceAccent)
                                Text("Trip Details")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            TextField("Trip Title", text: $trip.title)
                                .textFieldStyle(IceTextFieldStyle())
                            
                            TextField("Location", text: $trip.location)
                                .textFieldStyle(IceTextFieldStyle())
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.iceCardBlue)
                        )
                        
                        // Results
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.iceSuccess)
                                Text("Results")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("BITE SCORE")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.iceTextSecondary)
                                    .tracking(0.5)
                                
                                HStack(spacing: 20) {
                                    ForEach(1...5, id: \.self) { score in
                                        Button(action: {
                                            withAnimation(.spring(response: 0.3)) {
                                                trip.biteScore = score
                                            }
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(score <= trip.biteScore ? colorForBiteScore(score) : Color.iceDivider)
                                                    .frame(width: 48, height: 48)
                                                
                                                Text("\(score)")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .scaleEffect(score == trip.biteScore ? 1.15 : 1.0)
                                        .shadow(color: score == trip.biteScore ? colorForBiteScore(score).opacity(0.5) : Color.clear, radius: 8, x: 0, y: 4)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("CATCH COUNT")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.iceTextSecondary)
                                        .tracking(0.5)
                                    
                                    TextField("0", value: $trip.catchCount, format: .number)
                                        .textFieldStyle(IceTextFieldStyle())
                                        .keyboardType(.numberPad)
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("WEIGHT (KG)")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.iceTextSecondary)
                                        .tracking(0.5)
                                    
                                    TextField("Optional", value: $trip.totalWeight, format: .number)
                                        .textFieldStyle(IceTextFieldStyle())
                                        .keyboardType(.decimalPad)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.iceCardBlue)
                        )
                        
                        // Conditions
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "cloud.sun.fill")
                                    .foregroundColor(.iceAccent)
                                Text("Conditions")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            TextField("Temperature (°C)", value: $trip.temperature, format: .number)
                                .textFieldStyle(IceTextFieldStyle())
                                .keyboardType(.decimalPad)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("WIND")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.iceTextSecondary)
                                    .tracking(0.5)
                                
                                Picker("Wind", selection: $trip.wind) {
                                    ForEach(WindLevel.allCases, id: \.self) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .colorMultiply(.iceAccent)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("CLOUD")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.iceTextSecondary)
                                    .tracking(0.5)
                                
                                Picker("Cloud", selection: $trip.cloud) {
                                    ForEach(CloudLevel.allCases, id: \.self) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .colorMultiply(.iceAccent)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.iceCardBlue)
                        )
                        
                        if !isNewTrip {
                            Button(action: deleteTrip) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                    Text("Delete Trip")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.iceWarning)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(isNewTrip ? "New Trip" : "Edit Trip")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.iceTextSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTrip()
                    }
                    .foregroundColor(.iceAccent)
                    .font(.system(size: 17, weight: .semibold))
                }
            }
        }
    }
    
    func colorForBiteScore(_ score: Int) -> Color {
        switch score {
        case 4...5: return .iceSuccess
        case 2...3: return .iceAccent
        default: return .iceWarning
        }
    }
    
    func saveTrip() {
        if isNewTrip {
            dataManager.addTrip(trip)
        } else {
            dataManager.updateTrip(trip)
        }
        dismiss()
    }
    
    func deleteTrip() {
        dataManager.deleteTrip(trip)
        dismiss()
    }
}

// MARK: - Text Field Style
struct IceTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .background(Color.iceDarkBlue)
            .cornerRadius(12)
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .medium))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.iceDivider, lineWidth: 1)
            )
    }
}
