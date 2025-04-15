//
//  FirebaseAnalyticsProvider.swift
//  Focus
//
//  Created by Ryan Thomas on 4/8/25.
//


import FirebaseAnalytics

class FirebaseAnalyticsProvider: AnalyticsProvider {
    
    init() {
        InAppLogStore.shared.append("🚀 Firebase initialized", for: "Firebase")
    }
    
    func logEvent(name: String, parameters: [String: Any]?) {
        let stringParams = parameters?.mapValues { "\($0)" } ?? [:]
        InAppLogStore.shared.append("📊 Firebase logEvent: \(name) — \(stringParams)", for: "Firebase")
        Analytics.logEvent(name, parameters: parameters)
    }

    func logScreenView(name: String) {
        InAppLogStore.shared.append("📺 Firebase screen_view: \(name)", for: "Firebase")
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: String(describing: type(of: self))
        ])
    }

    func setUser(id: String?) {
        let log = "👤 Firebase setUser: \(id ?? "nil")"
        InAppLogStore.shared.append(log, for: "Firebase")
        Analytics.setUserID(id)
    }
}
