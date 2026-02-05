
import SwiftUI

// MARK: - Main App
@main
struct IceBiteCalendarApp: App {
    @StateObject private var dataManager = DataManager()
    
    init() {
        // Configure navigation bar appearance for iOS 15
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.iceDarkBlue)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            if dataManager.hasSeenOnboarding {
                MainTabView()
                    .environmentObject(dataManager)
            } else {
                SplashView()
                    .environmentObject(dataManager)
            }
        }
    }
}
