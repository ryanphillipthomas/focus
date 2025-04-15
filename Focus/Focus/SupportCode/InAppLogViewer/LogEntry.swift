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
    case event, screen, user, startup, generic

    var symbolName: String {
        switch self {
        case .event: return "chart.bar.fill"
        case .screen: return "rectangle.stack.fill"
        case .user: return "person.crop.circle.fill"
        case .startup: return "sparkles"
        case .generic: return "doc.text.fill"
        }
    }

    var color: Color {
        switch self {
        case .event: return .green
        case .screen: return .blue
        case .user: return .orange
        case .startup: return .purple
        case .generic: return .gray
        }
    }
}


