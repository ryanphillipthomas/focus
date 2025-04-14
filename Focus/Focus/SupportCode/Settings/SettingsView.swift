//
//  SettingsView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.

import SwiftUI
import SwiftData
import StoreKit


struct SettingsView: View {
    @EnvironmentObject var model: ThemeModel

    @StateObject private var calendarManager = CalendarManager()
    @StateObject private var calendarViewModel = CalendarListViewModel()
    @StateObject private var musicManager = AppleMusicManager()
    @StateObject private var reminderManager = ReminderManager()
    @StateObject private var healthManager = HealthManager()
    @StateObject private var iCloudStatus = iCloudStatusManager()
    @Bindable var auth: AuthViewModel

    
    @AppStorage("isProUser") private var isProUser: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
        
    @State private var activeSheet: SettingsSheet?
    @State private var showSubscriptionSheet = false
    @State private var showCalendarPicker = false
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var focusItems: [Item] // Replace with your model name

    var body: some View {
        Form {
            // ANALYTICS
            Section(header: Text("Analytics")) {
                VStack {
                    Spacer()
                    HStack{
                        Text("Firebase Analytics")
                        Spacer()
                        Text("Enabled")
                    }
                    Spacer()
                    HStack{
                        Text("Mixpanel Analytics")
                        Spacer()
                        Text("Enabled")
                    }
                    Spacer()
                }
            }
            // ANALYTICS
            
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
            
            // FIREBASE
            Section(header: Text("Firebase")) {
                Section {
                    Button() {
                        activeSheet = .authencation
                    } label: {
                        Label("Log In", systemImage: "arrow.forward.square")
                    }
                    
                    Button(role: .destructive) {
                        auth.signOut()
                    } label: {
                        Label("Log Out", systemImage: "arrow.backward.square")
                    }
                }
            }
            // FIREBASE
            
            // HEALTH
            Section(header: Text("Health")) {
                NavigationLink(destination: HealthStatsListView()) {
                    Label("Health", systemImage: "heart")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_refresh_health")
                })
            }
            // HEALTH
            
            
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
            
            // NOTIFICATIONS
            Section(header: Text("Notifications")) {
                NavigationLink(destination: NotificationTestView()) {
                    Label("Notifications", systemImage: "bell")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_manage_notifications")
                })
            }
            // NOTIFICATIONS
            
            
            // ONBOARDING
            Section(header: Text("Onboarding")) {
                Button("Reset Onboarding") {
                    AnalyticsManager.shared.logEvent("settings_selection_reset_onboarding")
                    hasCompletedOnboarding = false
                }
                .foregroundColor(.red)
            }
            // ONBOARDING
            
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
            
            // SUBSCRIPTIONS
            Section(header: Text("Subscriptions")) {
                HStack {
                    Label("Status", systemImage: isProUser ? "checkmark.seal.fill" : "xmark.seal")
                    Spacer()
                    Text(isProUser ? "Paid" : "Free")
                        .foregroundColor(isProUser ? .green : .secondary)
                }

                Button("Manage Subscription") {
                    AnalyticsManager.shared.logEvent("settings_selection_upgrade_to_pro")
                    activeSheet = .subscription
                }
            }
            // SUBSCRIPTIONS
            
            
            // THEME
            Section(header: Text("Theme")) {
                NavigationLink(destination: ThemeSelectionView()) {
                    Label("Theme", systemImage: "paintpalette")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_customize")
                })
            }
            // THEME


            // ADVANCED
            Section(header: Text("Advanced")) {

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
        .navigationTitle("Support Code")
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
                    ThemeSelectionView()
                }
            case .notificationsPicker:
                NavigationView {
                    NotificationTestView()
                }
            case .authencation:
                NavigationView {
                    AuthView(auth: auth)
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
