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
    @StateObject private var musicManager = AppleMusicManager()

    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("isSpotifyConnected") private var isSpotifyConnected = false
    
    @StateObject private var calendarViewModel = CalendarListViewModel()
    @State private var showCalendarPicker = false
    
    @Environment(\.modelContext) private var modelContext
    @Query private var focusItems: [Item] // Replace with your model name

    var body: some View {
        Form {
            Section(header: Text("Integrations")) {
                //
                Button("Choose Calendar") {
                    showCalendarPicker = true
                }

                HStack {
                    Text("Selected Calendar")
                    Spacer()
                    Text(calendarViewModel.selectedCalendarTitle())
                        .foregroundColor(.secondary)
                }
            //
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
        //
        .sheet(isPresented: $showCalendarPicker) {
            NavigationView {
                CalendarListView(viewModel: calendarViewModel)
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
