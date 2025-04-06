//
//  ItemDetailView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
import UserNotifications

struct ItemDetailView: View {
    @Bindable var item: Item
    @Environment(\.modelContext) private var modelContext
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 20) {
            if item.isTimerRunning {
                Text("Time Remaining: \(timeFormatted)")
                    .font(.title)
                    .monospacedDigit()
            }

            Button(item.isTimerRunning ? "Stop Timer" : "Start 2-Min Timer") {
                item.isTimerRunning ? stopTimer() : startTimer()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onDisappear {
            stopTimer()
            save()
        }
    }

    var timeFormatted: String {
        let minutes = item.secondsRemaining / 60
        let seconds = item.secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startTimer() {
        item.secondsRemaining = 120
        item.isTimerRunning = true
        save()
        scheduleNotification()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if item.secondsRemaining > 0 {
                item.secondsRemaining -= 1
                save()
            } else {
                stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        item.isTimerRunning = false
        save()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["focus_timer"])
    }

    func save() {
        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to save item: \(error)")
        }
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Focus Session Complete"
        content.body = "Your 2-minute timer is done."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: false)

        let request = UNNotificationRequest(identifier: "focus_timer", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            } else {
                print("🔔 Notification scheduled.")
            }
        }
    }
}
