
import Foundation

// MARK: - Trip Model
struct Trip: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var title: String
    var startTime: Date?
    var endTime: Date?
    var location: String
    var notes: String
    var biteScore: Int
    var catchCount: Int
    var totalWeight: Double?
    var fishSpecies: [String]
    var temperature: Double?
    var pressure: Double?
    var wind: WindLevel
    var cloud: CloudLevel
}

// MARK: - Enums
enum WindLevel: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum CloudLevel: String, Codable, CaseIterable {
    case clear = "Clear"
    case normal = "Normal"
    case overcast = "Overcast"
}

// MARK: - Gear Models
struct GearItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var isChecked: Bool
}

struct GearPreset: Identifiable {
    var id = UUID()
    var name: String
    var items: [String]
}
