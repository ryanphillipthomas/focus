//
//  AccentColorOption.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//
import SwiftUI

enum AccentColorOption: String, CaseIterable {
    case blue
    case green
    case red
    case purple
    case orange  // default (AccentColor)

    var color: Color {
        switch self {
        case .blue: return Color("AccentBlue")
        case .green: return Color("AccentGreen")
        case .red: return Color("AccentRed")
        case .purple: return Color("AccentPurple")
        case .orange: return Color("AccentColor") // default
        }
    }

    var displayName: String {
        switch self {
        case .blue: return "Blue"
        case .green: return "Green"
        case .red: return "Red"
        case .purple: return "Purple"
        case .orange: return "Orange"
        }
    }
}
