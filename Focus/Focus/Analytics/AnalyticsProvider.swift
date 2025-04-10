//
//  AnalyticsProvider.swift
//  Focus
//
//  Created by Ryan Thomas on 4/8/25.
//


protocol AnalyticsProvider {
    func logEvent(name: String, parameters: [String: Any]?)
    func logScreenView(name: String)
    func setUser(id: String?)
}
