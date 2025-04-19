//
//  Untitled.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//

import SwiftUI

struct LogEntry: Identifiable {
    let id = UUID()
    let message: String
    let timestamp: Date
    let type: LogType
}

enum LogType {
    case event, screen, user, startup, generic, health, calendar, authentication, icloud, music, notifications, crash, onboarding, reminders, cache, api

    var symbolName: String {
        switch self {
        case .event: return "chart.bar.fill"
        case .screen: return "rectangle.stack.fill"
        case .user: return "person.crop.circle.fill"
        case .startup: return "sparkles"
        case .generic: return "doc.text.fill"
        case .health: return "heart.fill"
        case .calendar: return "calendar"
        case .authentication: return "lock.fill"
        case .icloud: return "icloud"
        case .music: return "music.note"
        case .notifications: return "bell.fill"
        case .crash: return "exclamationmark.triangle.fill"
        case .onboarding: return "hand.tap.fill"
        case .reminders: return "checkmark.circle.fill"
        case .cache: return "internaldrive.fill"
        case .api: return "network"
        }
    }

    var color: Color {
        switch self {
        case .event: return .green
        case .screen: return .blue
        case .user: return .orange
        case .startup: return .purple
        case .generic: return .gray
        case .health: return .red
        case .calendar: return .indigo
        case .authentication: return .teal
        case .icloud: return .blue
        case .music: return .pink
        case .notifications: return .yellow
        case .crash: return .red
        case .onboarding: return .mint
        case .reminders: return .cyan
        case .cache: return .brown
        case .api: return .blue
        }
    }
}

extension LogType: CaseIterable, Identifiable {
    var id: Self { self }
}
