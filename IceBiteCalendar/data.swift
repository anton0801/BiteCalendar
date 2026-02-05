
import Foundation
import Combine

// MARK: - Data Manager
class DataManager: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var hasSeenOnboarding: Bool = false
    @Published var monthlyGoal: Int = 4
    @Published var fishSpeciesList: [String] = ["Perch", "Pike", "Roach", "Bream"]
    
    init() {
        loadData()
    }
    
    func addTrip(_ trip: Trip) {
        trips.append(trip)
        saveData()
    }
    
    func updateTrip(_ trip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index] = trip
            saveData()
        }
    }
    
    func deleteTrip(_ trip: Trip) {
        trips.removeAll { $0.id == trip.id }
        saveData()
    }
    
    func tripsForDate(_ date: Date) -> [Trip] {
        trips.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: "trips")
        }
        UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding")
        UserDefaults.standard.set(monthlyGoal, forKey: "monthlyGoal")
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "trips"),
           let decoded = try? JSONDecoder().decode([Trip].self, from: data) {
            trips = decoded
        }
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        monthlyGoal = UserDefaults.standard.integer(forKey: "monthlyGoal")
        if monthlyGoal == 0 { monthlyGoal = 4 }
    }
    
    func resetAllData() {
        trips = []
        UserDefaults.standard.removeObject(forKey: "trips")
        saveData()
    }
}
