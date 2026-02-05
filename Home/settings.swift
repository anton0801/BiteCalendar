
import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingResetAlert = false
    @State private var showingGoalEditor = false
    @State private var monthlyGoal: String
    
    init() {
        _monthlyGoal = State(initialValue: "4")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.iceDarkBlue.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Goals Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("GOALS")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.iceTextSecondary)
                                .tracking(0.5)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                Button(action: {
                                    showingGoalEditor = true
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Monthly Goal")
                                                .font(.system(size: 17, weight: .regular))
                                                .foregroundColor(.white)
                                            Text("\(dataManager.monthlyGoal) trips per month")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(.iceTextSecondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.iceTextSecondary)
                                    }
                                    .padding()
                                    .background(Color.iceCardBlue)
                                }
                            }
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // Data Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("DATA")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.iceTextSecondary)
                                .tracking(0.5)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                Button(action: {
                                    showingResetAlert = true
                                }) {
                                    HStack {
                                        Text("Reset All Data")
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundColor(.iceWarning)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.iceCardBlue)
                                }
                            }
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // About Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("ABOUT")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.iceTextSecondary)
                                .tracking(0.5)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Text("Version")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.iceTextSecondary)
                                        .font(.system(size: 17, weight: .regular))
                                }
                                .padding()
                                .background(Color.iceCardBlue)
                            }
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                monthlyGoal = "\(dataManager.monthlyGoal)"
            }
            .sheet(isPresented: $showingGoalEditor) {
                GoalEditorView(monthlyGoal: $monthlyGoal)
                    .environmentObject(dataManager)
            }
            .alert("Reset All Data?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    dataManager.resetAllData()
                }
            } message: {
                Text("This will permanently delete all your trips and cannot be undone.")
            }
        }
    }
}

// MARK: - Goal Editor View
struct GoalEditorView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @Binding var monthlyGoal: String
    @State private var localGoal: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.iceDarkBlue.ignoresSafeArea()
                
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Image(systemName: "target")
                            .font(.system(size: 60))
                            .foregroundColor(.iceAccent)
                        
                        Text("Set Monthly Goal")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("How many fishing trips do you want to complete each month?")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.iceTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 20) {
                        TextField("Enter number", text: $localGoal)
                            .keyboardType(.numberPad)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.iceAccent)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.iceCardBlue)
                            .cornerRadius(16)
                            .padding(.horizontal, 40)
                        
                        Text("trips per month")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.iceTextSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: saveGoal) {
                        Text("Save Goal")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.iceAccent)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.iceTextSecondary)
                }
            }
            .onAppear {
                localGoal = monthlyGoal
            }
        }
    }
    
    func saveGoal() {
        if let goal = Int(localGoal), goal > 0 {
            dataManager.monthlyGoal = goal
            monthlyGoal = localGoal
            dataManager.saveData()
            dismiss()
        }
    }
}
