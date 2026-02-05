
import SwiftUI

// MARK: - Color Theme
extension Color {
    static let iceDarkBlue = Color(hex: "071B27")
    static let iceCardBlue = Color(hex: "0F2F42")
    static let iceAccent = Color(hex: "4FC3F7")
    static let iceSuccess = Color(hex: "6FE3C1")
    static let iceWarning = Color(hex: "FF8A8A")
    static let iceTextSecondary = Color(hex: "9CB6C9")
    static let iceDivider = Color(hex: "123A4F")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
