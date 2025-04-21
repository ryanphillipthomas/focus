//
//  SettingsView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.

import SwiftUI
import SwiftData
import StoreKit

struct SettingItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var icon: String
    var destinationID: String
    var isVisible: Bool = true

    init(id: UUID = UUID(), title: String, icon: String, destinationID: String, isVisible: Bool = true) {
        self.id = id
        self.title = title
        self.icon = icon
        self.destinationID = destinationID
        self.isVisible = isVisible
    }
}

struct SettingSection: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var items: [SettingItem]
    var isVisible: Bool = true

    init(id: UUID = UUID(), title: String, items: [SettingItem], isVisible: Bool = true) {
        self.id = id
        self.title = title
        self.items = items
        self.isVisible = isVisible
    }
}

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
    @AppStorage("customSettingsLayout") private var savedSettingsData: Data?

    @State private var activeSheet: SettingsSheet?
    @State private var isEditing = false
    @State private var sections: [SettingSection] = []

    let contextualOptions: [ContextualSetting]

    var body: some View {
        NavigationStack {
            List {
                ForEach($sections) { $section in
                    if section.isVisible {
                        Section(header: Text(section.title)) {
                            ForEach($section.items) { $item in
                                if item.isVisible {
                                    HStack {
                                        if item.destinationID.hasPrefix("inlineButton") {
                                            resolveDestination(for: item.destinationID)
                                        } else {
                                            NavigationLink(destination: resolveDestination(for: item.destinationID)) {
                                                Label(item.title, systemImage: item.icon)
                                            }
                                        }
                                        if isEditing {
                                            Spacer()
                                            Button(role: .destructive) {
                                                item.isVisible = false
                                                saveSections()
                                            } label: {
                                                Label("Hide", systemImage: "minus.circle")
                                            }
                                            .labelStyle(.iconOnly)
                                        }
                                    }
                                }
                            }
                            .onMove { from, to in
                                section.items.move(fromOffsets: from, toOffset: to)
                                saveSections()
                            }
                        }
                    }
                }
                .onMove { from, to in
                    sections.move(fromOffsets: from, toOffset: to)
                    saveSections()
                }

                // Hidden Items Section
                if isEditing {
                    Section(header: Text("Hidden Items")) {
                        ForEach($sections) { $section in
                            ForEach($section.items) { $item in
                                if !item.isVisible {
                                    HStack {
                                        Label(item.title, systemImage: item.icon)
                                        Spacer()
                                        Button {
                                            item.isVisible = true
                                            saveSections()
                                        } label: {
                                            Label("Unhide", systemImage: "plus.circle")
                                        }
                                        .labelStyle(.iconOnly)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Done" : "Edit") {
                        isEditing.toggle()
                    }
                }
            }
            .onAppear {
                sections = loadSections()
            }
        }
        .analyticsScreen(self)
    }

    func saveSections() {
        do {
            let encoded = try JSONEncoder().encode(sections)
            savedSettingsData = encoded
        } catch {
            print("Failed to save settings layout: \(error)")
        }
    }

    func loadSections() -> [SettingSection] {
        guard let data = savedSettingsData else {
            return defaultSections()
        }
        do {
            return try JSONDecoder().decode([SettingSection].self, from: data)
        } catch {
            print("Failed to decode settings layout: \(error)")
            return defaultSections()
        }
    }

    func resolveDestination(for id: String) -> AnyView {
        switch id {
        case "charts": return AnyView(ChartView(manager: ChartManager()))
        case "gradientview": return AnyView(GradientView())
        case "tipkit": return AnyView(TipKitView())
        case "openai": return AnyView(OpenAIView())
        case "api": return AnyView(CharacterTestView())
        case "logs": return AnyView(InAppLogViewer(provider: "All"))
        case "gmail": return AnyView(GmailLogTriggerView(accessToken: auth.accessToken))
        case "analytics": return AnyView(AnalyticsSettingsListView())
        case "calendar": return AnyView(CalendarSettingsListView(calendarManager: calendarManager, calendarViewModel: calendarViewModel))
        case "auth": return AnyView(AuthenticationListView(auth: auth))
        case "health": return AnyView(HealthStatsListView())
        case "icloud": return AnyView(iCloudListView(iCloudStatus: iCloudStatus))
        case "music": return AnyView(MusicListView(musicManager: musicManager))
        case "notifications": return AnyView(NotificationTestView())
        case "onboarding": return AnyView(OnboardingListView(hasCompletedOnboarding: $hasCompletedOnboarding))
        case "reminders": return AnyView(RemindersListView(reminderManager: reminderManager))
        case "subscriptions": return AnyView(SubscriptionListView(viewModel: SubscriptionViewModel(mock: true)))
        case "theme": return AnyView(ThemeSelectionView())
        case "cache": return AnyView(CacheSettingsListView())
        case "review": return AnyView(AppReviewListView())
        case "contextual": return AnyView(ContextualSettingListView(title: "Advanced", options: contextualOptions))
        default:
            return AnyView(EmptyView())
        }
    }

    func defaultSections() -> [SettingSection] {
        [
            SettingSection(
                title: "General",
                items: [
                    SettingItem(title: "Charts", icon: "chart.bar", destinationID: "charts"),
                    SettingItem(title: "Gradient", icon: "rainbow", destinationID: "gradientview"),
                    SettingItem(title: "TipKit", icon: "lightbulb", destinationID: "tipkit"),
                    SettingItem(title: "OpenAI", icon: "message", destinationID: "openai"),
                    SettingItem(title: "API", icon: "network", destinationID: "api"),
                    SettingItem(title: "Gmail", icon: "envelope", destinationID: "gmail"),
                    SettingItem(title: "Logs", icon: "book.pages", destinationID: "logs"),
                    SettingItem(title: "Analytics", icon: "gear", destinationID: "analytics"),
                    SettingItem(title: "Calendar", icon: "calendar", destinationID: "calendar"),
                    SettingItem(title: "Authentication", icon: "lock", destinationID: "auth"),
                    SettingItem(title: "Health", icon: "heart", destinationID: "health"),
                    SettingItem(title: "iCloud", icon: "icloud", destinationID: "icloud"),
                    SettingItem(title: "Music", icon: "music.quarternote.3", destinationID: "music"),
                    SettingItem(title: "Push Notifications", icon: "bell", destinationID: "notifications"),
                    SettingItem(title: "Onboarding", icon: "chart.line.text.clipboard", destinationID: "onboarding"),
                    SettingItem(title: "Reminders", icon: "checklist", destinationID: "reminders"),
                    SettingItem(title: "Subscriptions", icon: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90", destinationID: "subscriptions"),
                    SettingItem(title: "Theme", icon: "paintpalette", destinationID: "theme"),
                    SettingItem(title: "Cache", icon: "externaldrive", destinationID: "cache"),
                    SettingItem(title: "Review App", icon: "star", destinationID: "review")
                ]
            ),
            SettingSection(
                title: "Advanced",
                items: [
                    SettingItem(title: "Contextual Settings", icon: "slider.horizontal.3", destinationID: "contextual")
                ]
            )
        ]
    }
}
