//
//  FirebaseAnalyticsProvider.swift
//  Focus
//
//  Created by Ryan Thomas on 4/8/25.
//


import FirebaseAnalytics

class FirebaseAnalyticsProvider: AnalyticsProvider {
    func logEvent(name: String, parameters: [String: Any]?) {
        print("📊 Firebase logEvent: \(name) \(parameters ?? [:])")
        Analytics.logEvent(name, parameters: parameters)
    }

    func logScreenView(name: String) {
        print("📺 Firebase screen_view: \(name)")
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                               AnalyticsParameterScreenName: name,
                               AnalyticsParameterScreenClass: String(describing: type(of: self))
                           ])
    }
    
    func setUser(id: String?) {
        Analytics.setUserID(id)
    }
}
