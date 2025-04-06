//
//  SettingsView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.

import SwiftUI
import SwiftData
import StoreKit


struct SettingsView: View {
    @StateObject private var calendarManager = CalendarManager()

    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("isCalendarConnected") private var isCalendarConnected = false
    @AppStorage("isAppleMusicConnected") private var isAppleMusicConnected = false
    @AppStorage("isSpotifyConnected") private var isSpotifyConnected = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var focusItems: [Item] // Replace with your model name

    var body: some View {
        Form {
            Section(header: Text("Integrations")) {
                // Start calendar sync or disconnect
                if isCalendarConnected {
                    Button("Add Test Focus Event") {
                        calendarManager.createTestEvent()
                    }
                } else {
                    Button("Request Access"){
                        calendarManager.requestAccess { granted in
                            if !granted {
                                isCalendarConnected = false
                            }
                        }
                    }
                }

                Button(isAppleMusicConnected ? "Disconnect Apple Music" : "Connect Apple Music") {
                    // Launch Apple Music authorization
                }

                Button(isSpotifyConnected ? "Disconnect Spotify" : "Connect Spotify") {
                    // Launch Spotify OAuth flow
                }
            }
            
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
        .navigationTitle("Settings")
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
