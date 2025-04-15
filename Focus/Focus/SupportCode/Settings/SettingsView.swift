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
    
    let inlineContextualOptions: [ContextualSetting]
    let groupedContextualOptions: [ContextualSetting]

    var body: some View {
        Form {
        Section(header: Text(LocalizedStringResource("support_code_library_version"))) {
                NavigationLink(destination: AnalyticsSettingsListView()) {
                    Label("Analytics", systemImage: "gear")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_analytics")
                })

                NavigationLink(destination: CalendarSettingsListView(calendarManager: calendarManager, calendarViewModel: calendarViewModel)) {
                    Label("Calendar", systemImage: "calendar")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_authentication")
                })

                NavigationLink(destination: AuthenticationListView(auth: auth)) {
                    Label("Authentication", systemImage: "lock")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_authentication")
                })

                NavigationLink(destination: HealthStatsListView()) {
                    Label("Health", systemImage: "heart")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_refresh_health")
                })

                NavigationLink(destination: MusicListView(musicManager: musicManager)) {
                    Label("iCloud", systemImage: "icloud")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_refresh_icloud")
                })

                NavigationLink(destination: MusicListView(musicManager: musicManager)) {
                    Label("Music", systemImage: "music.quarternote.3")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_connect_apple_music")
                })

                NavigationLink(destination: NotificationTestView()) {
                    Label("Push Notifications", systemImage: "bell")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_manage_notifications")
                })

                NavigationLink(destination: OnboardingListView(hasCompletedOnboarding: $hasCompletedOnboarding)) {
                    Label("Onboarding", systemImage: "chart.line.text.clipboard")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_onboarding")
                })

                NavigationLink(destination: RemindersListView(reminderManager:reminderManager)) {
                    Label("Reminders", systemImage: "checklist")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_reminders")
                })

                NavigationLink(destination: SubscriptionListView(viewModel: SubscriptionViewModel(mock: true))) {
                    Label("Subscriptions", systemImage: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_upgrade_to_pro")
                })

                NavigationLink(destination: ThemeSelectionView()) {
                    Label("Theme", systemImage: "paintpalette")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_customize")
                })
            
                NavigationLink(destination: CacheSettingsListView()) {
                    Label("Cache", systemImage: "externaldrive")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_cache")
                })
            
                NavigationLink(destination: AppReviewListView()) {
                    Label("Review App", systemImage: "star")
                }.simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.shared.logEvent("settings_selection_rate")
                })
            }
            
            Section(header: Text("Advanced")) {
                // Inline contextual actions
                ForEach(inlineContextualOptions) { option in
                    Button {
                        option.action()
                    } label: {
                        if let image = option.systemImage {
                            Label {
                                Text(option.title)
                            } icon: {
                                Image(systemName: image)
                            }
                        } else {
                            Text(option.title)
                        }
                    }
                }
                
                // Grouped options as a navigation link
                if !groupedContextualOptions.isEmpty {
                    NavigationLink("Contextual Settings") {
                        ContextualSettingListView(
                            title: "Advanced",
                            options: groupedContextualOptions
                        )
                    }
                }
            }
        }
        .navigationTitle("Support Code")
        .analyticsScreen(self)
    }
}
