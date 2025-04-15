//
//  FirebaseAnalyticsProvider.swift
//  Focus
//
//  Created by Ryan Thomas on 4/8/25.
//


import FirebaseAnalytics

class FirebaseAnalyticsProvider: AnalyticsProvider {
    
    init() {
        InAppLogStore.shared.append("Initialized", for: "Firebase", type: .startup)
    }
    
    func logEvent(name: String, parameters: [String: Any]?) {
        let stringParams = parameters?.mapValues { "\($0)" } ?? [:]
        InAppLogStore.shared.append("Event: \(name) — \(stringParams)", for: "Firebase", type: .event)
        Analytics.logEvent(name, parameters: parameters)
    }

    func logScreenView(name: String) {
        InAppLogStore.shared.append("Screen: \(name)", for: "Firebase", type: .screen)
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: String(describing: type(of: self))
        ])
    }

    func setUser(id: String?) {
        let log = "Identified user: \(id ?? "nil")"
        InAppLogStore.shared.append(log, for: "Firebase", type: .user)
        Analytics.setUserID(id)
    }
}
