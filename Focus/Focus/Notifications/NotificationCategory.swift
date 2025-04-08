//
//  NotificationCategory.swift
//  Focus
//
//  Created by Ryan Thomas on 4/7/25.
//


enum NotificationCategory: String, CaseIterable, Codable {
    case schedule
    case focus
    case smartNudge
    case task
    case integration
    case theme
}

struct NotificationType: Identifiable, Codable, Hashable {
    let id: String                  // unique ID like "blockStarting"
    let title: String              // display name
    let description: String        // optional blurb
    let category: NotificationCategory
    var isEnabled: Bool            // user preference toggle
}
