//
//  WithSettingsOverlay.swift
//  Focus
//
//  Created by Ryan Thomas on 4/11/25.

import SwiftUI

struct WithSettingsOverlay<Content: View>: View {
    @State private var showSettings = false
    @EnvironmentObject var model: ThemeModel
    @State var auth = AuthViewModel()

    let content: Content
    let inlineContextualOptions: [ContextualSetting]
    let groupedContextualOptions: [ContextualSetting]

    init(
        inlineContextualOptions: [ContextualSetting] = [],
        groupedContextualOptions: [ContextualSetting] = [],
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.inlineContextualOptions = inlineContextualOptions
        self.groupedContextualOptions = groupedContextualOptions
    }

    var body: some View {
        ZStack {
            content
            SettingsButtonView(showSettings: $showSettings)
        }
        .sheet(isPresented: $showSettings) {
            SettingsModalView(
                auth: auth,
                inlineContextualOptions: inlineContextualOptions,
                groupedContextualOptions: groupedContextualOptions
            )
            .environmentObject(model)
        }
    }
}
