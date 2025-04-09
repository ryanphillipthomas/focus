//
//  AnalyticsManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/8/25.
//


class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private var providers: [AnalyticsProvider] = []

    private init() {
        // Add your providers here
        providers.append(FirebaseAnalyticsProvider())
        // Future: providers.append(MixpanelProvider())
    }

    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        providers.forEach { $0.logEvent(name: name, parameters: parameters) }
    }

    func logScreen(_ name: String) {
        providers.forEach { $0.logScreenView(name: name) }
    }
}
