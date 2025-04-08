
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//

import SwiftUI

enum AppIcon: String, CaseIterable {
    case `default` = "AppIcon"
    case red = "AppIcon-Red"
    case blue = "AppIcon-Blue"
    case green = "AppIcon-Green"
    case purple = "AppIcon-Purple"

    var iconName: String? {
        switch self {
        case .default: return nil // iOS uses `nil` for the primary icon
        default: return self.rawValue
        }
    }

    var displayName: String {
        switch self {
        case .default: return "Default"
        case .red: return "Red"
        case .blue: return "Blue"
        case .green: return "Green"
        case .purple: return "Purple"
        }
    }

    var previewName: String {
        switch self {
        case .default: return "AppIconPreview"
        case .red: return "AppIconRedPreview"
        case .blue: return "AppIconBluePreview"
        case .green: return "AppIconGreenPreview"
        case .purple: return "AppIconPurplePreview"
        }
    }
}
