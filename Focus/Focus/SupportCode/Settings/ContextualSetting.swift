//
//  ContextualSetting.swift
//  Focus
//
//  Created by Ryan Thomas on 4/15/25.
//

import SwiftUI

struct ContextualSetting: Identifiable {
    let id = UUID()
    let title: LocalizedStringResource
    let systemImage: String?
    let action: () -> Void
}
