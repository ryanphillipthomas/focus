//
//  SettingsView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.

import SwiftUI
import SwiftData
import StoreKit


struct SettingsView: View {
    @EnvironmentObject var model: Model

    @StateObject private var calendarManager = CalendarManager()
    @StateObject private var calendarViewModel = CalendarListViewModel()
    @StateObject private var musicManager = AppleMusicManager()
    @StateObject private var reminderManager = ReminderManager()
    @StateObject private var healthManager = HealthManager()
    @StateObject private var iCloudStatus = iCloudStatusManager()

    
    @AppStorage("isProUser") private var isProUser: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
        
    @State private var activeSheet: SettingsSheet?
    @State private var showSubscriptionSheet = false
    @State private var showCalendarPicker = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var focusItems: [Item] // Replace with your model name

    var body: some View {
        Form {
            
            // PRO
            Section(header: Text("Account")) {
                HStack {
                    Label("Status", systemImage: isProUser ? "checkmark.seal.fill" : "xmark.seal")
                    Spacer()
                    Text(isProUser ? "Focx Pro" : "Free")
                        .foregroundColor(isProUser ? .green : .secondary)
                }

                Button("Upgrade to Pro 🚀") {
                    activeSheet = .subscription
                }
            }
            // PRO
            
            // HEALTH
            Section(header: Text("Health")) {
                if healthManager.isAuthorized {
                    HStack {
                        Label("Steps Today", systemImage: "figure.walk")
                        Spacer()
                        Text("\(Int(healthManager.stepCountToday))")
                    }

                    HStack {
                        Label("Sleep Last Night", systemImage: "bed.double.fill")
                        Spacer()
                        Text(String(format: "%.1f hrs", healthManager.sleepHoursLastNight))
                    }

                    Button("Refresh Health Data") {
                        Task {
                            await healthManager.fetchHealthData()
                        }
                    }
                } else {
                    Button("Connect Apple Health") {
                        Task {
                            await healthManager.requestAuthorization()
                        }
                    }
                }
            }
            // HEALTH
            
            // CUSTOMIZATION
            Section(header: Text("Appearance")) {
                Button("Customize") {
                    activeSheet = .appearancePicker
                }
            }

            // CUSTOMIZATION
            
            // ICLOUD
            Section(header: Text("iCloud")) {
                HStack {
                    Label("iCloud Sync", systemImage: "icloud")
                    Spacer()
                    Text(iCloudStatus.iCloudAvailable ? "Active ✅" : "Unavailable ❌")
                        .foregroundColor(iCloudStatus.iCloudAvailable ? .green : .secondary)
                }

                Button("Refresh iCloud Status") {
                    iCloudStatus.checkiCloudStatus()
                }
            }

            // ICLOUD
            
            // NOTIFICATIONS
            Section(header: Text("Notifications")) {
                Button("Manage Notification Settings") {
                    activeSheet = .notificationsPicker
                }
            }

            // NOTIFICATIONS
            
            // CALENDAR
            Section(header: Text("Calendar")) {
                Button("Choose Calendar") {
                    activeSheet = .calendarPicker
                }
                
                HStack {
                    Text("Selected Calendar")
                    Spacer()
                    Text(calendarViewModel.selectedCalendarTitle())
                        .foregroundColor(.secondary)
                }
                if calendarManager.isAuthorized {
                    Label("Connected to Calendar", systemImage: "checkmark.circle")
                        .foregroundColor(.green)
                } else {
                    Button("Enable Calendar Access") {
                        calendarManager.requestAccess { granted in
                            if granted {
                                print("✅ Calendar access granted by user.")
                            } else {
                                print("❌ Calendar access denied by user.")
                            }
                        }
                    }
                }
            }
            // CALENDAR

            // REMINDERS
            Section(header: Text("Reminders")) {
                if reminderManager.isAuthorized {
                    Label("Connected to Reminders", systemImage: "checkmark.circle")
                        .foregroundColor(.green)

                    ForEach(reminderManager.reminders.prefix(5), id: \.calendarItemIdentifier) { reminder in
                        Text(reminder.title)
                    }

                    Button("Fetch Reminders") {
                        reminderManager.fetchReminders()
                    }

                    Button("Add Test Reminder") {
                        reminderManager.addReminder(title: "Test Reminder", dueDate: Date().addingTimeInterval(3600))
                    }

                } else {
                    Button("Enable Reminder Access") {
                        reminderManager.requestAccess { granted in
                            print(granted ? "✅ Reminder access granted" : "❌ Reminder access denied")
                        }
                    }
                }
            }

            // REMINDERS

            // MUSIC
            Section(header: Text("Music")) {
                if musicManager.isAuthorized {
                    Button("Play Sample Song") {
                        Task {
                            await musicManager.requestAccess() // ensures auth
                            await musicManager.playSampleSong() //play song
                        }
                    }
                    .disabled(!musicManager.isAuthorized || !musicManager.isSubscribed)
                    
                    Label("Connected to Apple Music", systemImage: "checkmark.circle")
                        .foregroundColor(.green)
                } else {
                    Button("Connect Apple Music") {
                        Task {
                            await musicManager.requestAccess()
                        }
                    }
                }

                if !musicManager.statusMessage.isEmpty {
                    Text(musicManager.statusMessage)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            // MUSIC

            // ADVANCED
            Section(header: Text("Advanced")) {
                Button("Reset Onboarding") {
                    hasCompletedOnboarding = false
                }
                .foregroundColor(.red)

                Button("Reset Focus List") {
                    resetFocusItems()
                }
                .foregroundColor(.red)
            }

            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("\(appVersion) (\(buildNumber))")
                        .foregroundColor(.secondary)
                }
                Button("Rate This App") {
                    requestReview()
                }
            }
        }
        // ADVANCED

        // ROOT
        .navigationTitle("Settings")
        
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .subscription:
                NavigationView {
                    SubscriptionListView(viewModel: SubscriptionViewModel(mock: true))
                }
            case .calendarPicker:
                NavigationView {
                    CalendarListView(viewModel: calendarViewModel)
                }
            case .appearancePicker:
                NavigationView {
                    CustomizationView()
                }
            case .notificationsPicker:
                NavigationView {
                    NotificationTestView()
                }
            }
        }
    }
    
    private func requestReview() {
    #if os(iOS)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            AppStore.requestReview(in: scene)
        }
    #elseif os(macOS)
        if let url = URL(string: "macappstore://itunes.apple.com/app/idYOUR_APP_ID?action=write-review") {
            NSWorkspace.shared.open(url)
        }
    #endif
    }


    private func resetFocusItems() {
        for item in focusItems {
            modelContext.delete(item)
        }

        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to delete focus items: \(error)")
        }
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
    }
}
