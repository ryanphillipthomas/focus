//
//  SettingsSheet.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//

import SwiftUI

enum SettingsSheet: Identifiable {
    case subscription
    case calendarPicker
    case appearancePicker

    var id: String {
        switch self {
        case .subscription: return "subscription"
        case .calendarPicker: return "calendar"
        case .appearancePicker: return "appearance"
        }
    }
}
