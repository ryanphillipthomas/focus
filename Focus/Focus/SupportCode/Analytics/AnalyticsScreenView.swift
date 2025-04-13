//
//  AnalyticsScreenView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/8/25.
//
import SwiftUI

struct AnalyticsScreenView: ViewModifier {
    let screenName: String

    init<V: View>(_ view: V) {
        self.screenName = String(describing: type(of: view))
    }

    func body(content: Content) -> some View {
        content.onAppear {
            AnalyticsManager.shared.logScreen(screenName)
        }
    }
}


extension View {
    func analyticsScreen(_ view: some View) -> some View {
        self.modifier(AnalyticsScreenView(view))
    }
}
