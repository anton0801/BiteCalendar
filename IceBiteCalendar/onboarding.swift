
import SwiftUI

// MARK: - Splash Screen
struct SplashView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showOnboarding = false
    @State private var scale: CGFloat = 0.95
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.iceDarkBlue.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "snowflake")
                    .font(.system(size: 60, weight: .ultraLight))
                    .foregroundColor(.iceAccent)
                
                Text("IceBite Calendar")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView()
                .environmentObject(dataManager)
        }
    }
}

// MARK: - Onboarding
struct OnboardingView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var currentPage = 0
    
    let pages: [(title: String, description: String, icon: String)] = [
        ("Plan and track every trip", "Mark your fishing days on the calendar and never miss a moment", "calendar"),
        ("Save notes, bite and catch results", "Log conditions, catches, and observations for each trip", "doc.text"),
        ("See your best days and patterns", "Analyze your success and find the perfect fishing conditions", "chart.bar")
    ]
    
    var body: some View {
        ZStack {
            Color.iceDarkBlue.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            icon: pages[index].icon,
                            title: pages[index].title,
                            description: pages[index].description
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        dataManager.hasSeenOnboarding = true
                        dataManager.saveData()
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.iceAccent)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        dataManager.hasSeenOnboarding = true
                        dataManager.saveData()
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.iceTextSecondary)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: icon)
                .font(.system(size: 80, weight: .ultraLight))
                .foregroundColor(.iceAccent)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                
                Text(description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.iceTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                appeared = true
            }
        }
    }
}
