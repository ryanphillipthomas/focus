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
                NavigationLink(destination: AnalyticsSettingsListView()) {
                    Label("Analytics", systemImage: "gear")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_analytics")
                })
            }
            // ANALYTICS
            
            // CALENDAR
            Section(header: Text("Calendar")) {
                NavigationLink(destination: CalendarSettingsListView(calendarManager: calendarManager, calendarViewModel: calendarViewModel)) {
                    Label("Calendar", systemImage: "calendar")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_authentication")
                })
            }
            // CALENDAR
            
            // AUTHENTICATION
            Section(header: Text("Authentication")) {
                NavigationLink(destination: AuthenticationListView(auth: auth)) {
                    Label("Authentication", systemImage: "lock")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_authentication")
                })
            }
            // AUTHENTICATION
            
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
                NavigationLink(destination: MusicListView(musicManager: musicManager)) {
                    Label("iCloud", systemImage: "icloud")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_refresh_icloud")
                })
            }
            // ICLOUD
            
            // MUSIC
            Section(header: Text("Music")) {
                NavigationLink(destination: MusicListView(musicManager: musicManager)) {
                    Label("Music", systemImage: "music.quarternote.3")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_connect_apple_music")
                })
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
                NavigationLink(destination: OnboardingListView(hasCompletedOnboarding: $hasCompletedOnboarding)) {
                    Label("Onboarding", systemImage: "chart.line.text.clipboard")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_onboarding")
                })
            }
            // ONBOARDING
            
            
            // REMINDERS
            Section(header: Text("Reminders")) {
                NavigationLink(destination: RemindersListView(reminderManager:reminderManager)) {
                    Label("Reminders", systemImage: "checklist")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_reminders")
                })
            }
            // REMINDERS
            
            // SUBSCRIPTIONS
            Section(header: Text("Subscriptions")) {
                NavigationLink(destination: SubscriptionListView(viewModel: SubscriptionViewModel(mock: true))) {
                    Label("Subscriptions", systemImage: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_upgrade_to_pro")
                })
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
