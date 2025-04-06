//
//  AppleMusicManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//


import Foundation
import Combine
import MusicKit

@MainActor
class AppleMusicManager: ObservableObject {
    @Published var isAuthorized: Bool = false
    @Published var isSubscribed: Bool = false
    @Published var statusMessage: String = ""


    init() {
        Task {
            await checkAuthorizationStatus()
        }
    }

    /// Requests access to Apple Music
    func requestAccess() async {
        let status = await MusicAuthorization.request()
        handleAuthorizationStatus(status)
    }

    /// Checks current authorization and subscription status
    func checkAuthorizationStatus() async {
        let status = MusicAuthorization.currentStatus
        handleAuthorizationStatus(status)
    }

    private func handleAuthorizationStatus(_ status: MusicAuthorization.Status) {
        switch status {
        case .authorized:
            isAuthorized = true
            statusMessage = "✅ Apple Music access granted."
            Task { await checkSubscriptionStatus() }
        case .notDetermined:
            isAuthorized = false
            statusMessage = "Apple Music access not determined."
        case .denied:
            isAuthorized = false
            statusMessage = "❌ Apple Music access denied."
        case .restricted:
            isAuthorized = false
            statusMessage = "❌ Apple Music access restricted."
        @unknown default:
            isAuthorized = false
            statusMessage = "⚠️ Unknown Apple Music auth status."
        }
        print(statusMessage)
    }

    private func checkSubscriptionStatus() async {
        do {
            let subscription = try await MusicSubscription.current
            isSubscribed = subscription.canPlayCatalogContent
            print("🎵 Apple Music subscription valid: \(isSubscribed)")
        } catch {
            isSubscribed = false
            print("❌ Failed to get Apple Music subscription status: \(error)")
        }
    }

    func playSampleSong(term: String = "Focus") async {
        // Step 1: Request Authorization
        let status = await MusicAuthorization.request()
        guard status == .authorized else {
            print("❌ Apple Music authorization denied.")
            return
        }

        do {
            // Step 2: Search for songs matching the term
            let request = MusicCatalogSearchRequest(term: term, types: [Song.self])
            let response = try await request.response()

            // Step 3: Use the first result found
            guard let song = response.songs.first else {
                print("🔍 No songs found for search term: \"\(term)\"")
                return
            }

            // Step 4: Set up the player and play the song
            let player = ApplicationMusicPlayer.shared
            player.queue = .init(for: [song])
            try await player.play()

            print("🎶 Now playing: \(song.title) by \(song.artistName)")

        } catch {
            print("❌ Failed to play song: \(error.localizedDescription)")
        }
    }
}
