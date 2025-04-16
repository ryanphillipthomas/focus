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

    func requestAccess() async {
        let status = await MusicAuthorization.request()
        handleAuthorizationStatus(status)
    }

    func checkAuthorizationStatus() async {
        let status = MusicAuthorization.currentStatus
        handleAuthorizationStatus(status)
    }

    private func handleAuthorizationStatus(_ status: MusicAuthorization.Status) {
        switch status {
        case .authorized:
            isAuthorized = true
            statusMessage = "Apple Music access granted."
            InAppLogStore.shared.append(statusMessage, for: "Music", type: .music)
            Task { await checkSubscriptionStatus() }
        case .notDetermined:
            isAuthorized = false
            statusMessage = "Apple Music access not determined."
            InAppLogStore.shared.append(statusMessage, for: "Music", type: .music)
        case .denied:
            isAuthorized = false
            statusMessage = "Apple Music access denied."
            InAppLogStore.shared.append(statusMessage, for: "Music", type: .music)
        case .restricted:
            isAuthorized = false
            statusMessage = "Apple Music access restricted."
            InAppLogStore.shared.append(statusMessage, for: "Music", type: .music)
        @unknown default:
            isAuthorized = false
            statusMessage = "Unknown Apple Music auth status."
            InAppLogStore.shared.append(statusMessage, for: "Music", type: .music)
        }
    }

    private func checkSubscriptionStatus() async {
        do {
            let subscription = try await MusicSubscription.current
            isSubscribed = subscription.canPlayCatalogContent
            let message = "Apple Music subscription valid: \(isSubscribed)"
            InAppLogStore.shared.append(message, for: "Music", type: .music)
        } catch {
            isSubscribed = false
            let message = "Failed to get Apple Music subscription status: \(error.localizedDescription)"
            InAppLogStore.shared.append(message, for: "Music", type: .music)
        }
    }

    func playSampleSong(term: String = "Focus") async {
        let status = await MusicAuthorization.request()
        guard status == .authorized else {
            let message = "Apple Music authorization denied."
            InAppLogStore.shared.append(message, for: "Music", type: .music)
            return
        }

        do {
            let request = MusicCatalogSearchRequest(term: term, types: [Song.self])
            let response = try await request.response()

            guard let song = response.songs.first else {
                let message = "No songs found for search term: \"\(term)\""
                InAppLogStore.shared.append(message, for: "Music", type: .music)
                return
            }

            let player = ApplicationMusicPlayer.shared
            player.queue = .init(for: [song])
            try await player.play()

            let nowPlaying = "Now playing: \(song.title) by \(song.artistName)"
            InAppLogStore.shared.append(nowPlaying, for: "Music", type: .music)

        } catch {
            let message = "Failed to play song: \(error.localizedDescription)"
            InAppLogStore.shared.append(message, for: "Music", type: .music)
        }
    }
}

