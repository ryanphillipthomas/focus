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
                    AnalyticsManager.shared.logEvent("settings_selection_upgrade_to_pro")
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
                            AnalyticsManager.shared.logEvent("settings_selection_refresh_health")
                            await healthManager.fetchHealthData()
                        }
                    }
                } else {
                    Button("Connect Apple Health") {
                        Task {
                            AnalyticsManager.shared.logEvent("settings_selection_connect_health")
                            await healthManager.requestAuthorization()
                        }
                    }
                }
            }
            // HEALTH
            
            // CUSTOMIZATION
            Section(header: Text("Appearance")) {
                Button("Customize") {
                    AnalyticsManager.shared.logEvent("settings_selection_customize")
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
                    AnalyticsManager.shared.logEvent("settings_selection_refresh_icloud")
                    iCloudStatus.checkiCloudStatus()
                }
            }

            // ICLOUD
            
            // NOTIFICATIONS
            Section(header: Text("Notifications")) {
                Button("Manage Notification Settings") {
                    AnalyticsManager.shared.logEvent("settings_selection_manage_notifications")
                    activeSheet = .notificationsPicker
                }
            }

            // NOTIFICATIONS
            
            // CALENDAR
            Section(header: Text("Calendar")) {
                Button("Choose Calendar") {
                    AnalyticsManager.shared.logEvent("settings_selection_choose_calendar")
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
                        AnalyticsManager.shared.logEvent("settings_selection_enable_calendar")
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
                        AnalyticsManager.shared.logEvent("settings_selection_fetch_reminders")
                        reminderManager.fetchReminders()
                    }

                    Button("Add Test Reminder") {
                        AnalyticsManager.shared.logEvent("settings_selection_add_test_reminder")
                        reminderManager.addReminder(title: "Test Reminder", dueDate: Date().addingTimeInterval(3600))
                    }

                } else {
                    Button("Enable Reminder Access") {
                        AnalyticsManager.shared.logEvent("settings_selection_enable_reminders")
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
                        AnalyticsManager.shared.logEvent("settings_selection_play_song")
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
                        AnalyticsManager.shared.logEvent("settings_selection_connect_apple_music")
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
                    AnalyticsManager.shared.logEvent("settings_selection_reset_onboarding")
                    hasCompletedOnboarding = false
                }
                .foregroundColor(.red)

                Button("Reset Focus List") {
                    AnalyticsManager.shared.logEvent("settings_selection_reset_focus_list")
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
        .analyticsScreen(self)
        
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
