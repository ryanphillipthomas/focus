//
//  ContextualSettingListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/15/25.
//


import SwiftUI

struct ContextualSettingListView: View {
    let title: LocalizedStringResource
    let options: [ContextualSetting]

    var body: some View {
        List {
            Section(header: Text(title)) {
                ForEach(options) { option in
                    Button {
                        option.action()
                    } label: {
                        if let icon = option.systemImage {
                            Label {
                                Text(option.title)
                            } icon: {
                                Image(systemName: icon)
                            }
                        } else {
                            Text(option.title)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text(title))
    }
}
