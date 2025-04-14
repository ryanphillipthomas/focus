//
//  SettingsSheet.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//

import SwiftUI

enum SettingsSheet: Identifiable {
    case authencation
    case subscription
    case calendarPicker
    case appearancePicker
    case notificationsPicker

    var id: String {
        switch self {
        case .authencation: return "authencation"
        case .subscription: return "subscription"
        case .calendarPicker: return "calendar"
        case .appearancePicker: return "appearance"
        case .notificationsPicker: return "notifications"
        }
    }
}
