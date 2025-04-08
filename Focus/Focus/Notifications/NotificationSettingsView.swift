//
//  NotificationSettingsView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/7/25.
//

import SwiftUI

struct NotificationSettingsView: View {
    @Bindable var preferences: UserNotificationPreferences

    var body: some View {
        List {
            ForEach(NotificationCategory.allCases, id: \.self) { category in
                Section(header: Text(category.rawValue.capitalized)) {
                    ForEach(preferences.preferences.filter { $0.category == category }) { notif in
                        Toggle(isOn: Binding(
                            get: { notif.isEnabled },
                            set: { newValue in
                                if let index = preferences.preferences.firstIndex(of: notif) {
                                    preferences.preferences[index].isEnabled = newValue
                                }
                            }
                        )) {
                            VStack(alignment: .leading) {
                                Text(notif.title)
                                Text(notif.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Notifications")
    }
}
