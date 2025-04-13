//
//  UserNotificationPreferences.swift
//  Focus
//
//  Created by Ryan Thomas on 4/7/25.
//

import SwiftUI

@Observable
class UserNotificationPreferences: Codable {
    var preferences: [NotificationType]

    init(preferences: [NotificationType]) {
        self.preferences = preferences
    }
}


extension UserNotificationPreferences {
    static var defaultPreferences: UserNotificationPreferences {
        UserNotificationPreferences(preferences: [
            NotificationType(id: "upcomingBlock", title: "Upcoming Block Reminder", description: "Reminds you 5 minutes before a focus block starts.", category: .schedule, isEnabled: true),
            NotificationType(id: "blockStart", title: "Block Starting Now", description: "Let’s you know when your time block begins.", category: .schedule, isEnabled: true),
            NotificationType(id: "blockComplete", title: "Block Complete", description: "Notifies you when a time block ends.", category: .schedule, isEnabled: true),
            NotificationType(id: "focusSoundtrack", title: "Recommended Focus Track", description: "Suggests a focus soundtrack based on the block.", category: .focus, isEnabled: true),
            NotificationType(id: "autoAdjust", title: "Smart Reschedule Suggestion", description: "Prompts you to reschedule unstarted or overdue tasks.", category: .smartNudge, isEnabled: true),
            NotificationType(id: "taskReminder", title: "Task Completion Reminder", description: "Reminds you to mark tasks as complete.", category: .task, isEnabled: true),
            NotificationType(id: "calendarConflict", title: "Calendar Conflict", description: "Warns you when new events overlap your focus blocks.", category: .integration, isEnabled: true),
            NotificationType(id: "animalNudge", title: "Animal Profile Nudge", description: "Fun reminders from your theme animal!", category: .theme, isEnabled: false)
        ])
    }
}
