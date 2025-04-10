//
//  MixpanelAnalyticsProvider.swift
//  Focus
//
//  Created by Ryan Thomas on 4/8/25.
//

import Mixpanel

class MixpanelAnalyticsProvider: AnalyticsProvider {
    
    init(token: String) {
        Mixpanel.initialize(token: token, trackAutomaticEvents: false)
        print("🚀 Mixpanel initialized")
    }

    func logEvent(name: String, parameters: [String: Any]?) {
        let stringParams = parameters?
            .mapValues { "\($0)" } // Convert all values to String
            ?? [:] // Fallback to empty if nil

        print("📊 Logging event: \(name) — \(stringParams)")

        Mixpanel.mainInstance().track(event: name, properties: stringParams)
    }

    func logScreenView(name: String) {
        Mixpanel.mainInstance().track(event: "Screen Viewed", properties: ["screen_name": name])
    }
    
    func setUser(id: String?) {
        if let id = id {
            Mixpanel.mainInstance().identify(distinctId: id)
        } else {
            Mixpanel.mainInstance().reset()
        }
    }
}
