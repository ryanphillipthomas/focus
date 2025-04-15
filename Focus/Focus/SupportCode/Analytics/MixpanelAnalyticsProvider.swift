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
        InAppLogStore.shared.append("🚀 Mixpanel initialized", for: "Mixpanel")
    }

    func logEvent(name: String, parameters: [String: Any]?) {
        let stringParams = parameters?.mapValues { "\($0)" } ?? [:]
        InAppLogStore.shared.append("📊 Logging event: \(name) — \(stringParams)", for: "Mixpanel")
        Mixpanel.mainInstance().track(event: name, properties: stringParams)
    }

    func logScreenView(name: String) {
        InAppLogStore.shared.append("📺 Screen Viewed: \(name)", for: "Mixpanel")
        Mixpanel.mainInstance().track(event: "Screen Viewed", properties: ["screen_name": name])
    }

    func setUser(id: String?) {
        let log: String
        if let id = id {
            Mixpanel.mainInstance().identify(distinctId: id)
            log = "👤 Identified user: \(id)"
        } else {
            Mixpanel.mainInstance().reset()
            log = "👤 Reset user"
        }
        InAppLogStore.shared.append(log, for: "Mixpanel")
    }
}
