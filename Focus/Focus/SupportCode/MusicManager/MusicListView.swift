//
//  MusicListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI

struct MusicListView: View {
    @ObservedObject var musicManager: AppleMusicManager

    var body: some View {
        List {
            Section(header: Text("Music")) {
                if musicManager.isAuthorized {
                    Button("Play Sample Song") {
                        AnalyticsManager.shared.logEvent("settings_selection_play_song")
                        Task {
                            await musicManager.requestAccess() // revalidate access
                            await musicManager.playSampleSong()
                        }
                    }
                    .disabled(!musicManager.isSubscribed)
                } else {
                    Button("Connect Apple Music") {
                        AnalyticsManager.shared.logEvent("settings_selection_connect_apple_music")
                        Task {
                            await musicManager.requestAccess()
                        }
                    }
                }
                NavigationLink("Logs") {
                    InAppLogViewer(provider: "Music")
                }
            }
        }
    }
}
