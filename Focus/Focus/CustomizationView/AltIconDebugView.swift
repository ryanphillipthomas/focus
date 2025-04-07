//
//  AltIconDebugView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//


import SwiftUI

struct AltIconDebugView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Supports Alternate Icons?")
            Text(UIApplication.shared.supportsAlternateIcons ? "✅ Yes" : "❌ No")
                .foregroundColor(.blue)

            Button("Set AppIconRed") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIApplication.shared.setAlternateIconName("AppIconRed") { error in
                        if let error = error {
                            print("❌ ERROR: \(error.localizedDescription)")
                        } else {
                            print("✅ Success: Icon changed to AppIconRed")
                        }
                    }
                }
            }

            Button("Reset to Default") {
                UIApplication.shared.setAlternateIconName(nil) { error in
                    if let error = error {
                        print("❌ ERROR: \(error.localizedDescription)")
                    } else {
                        print("✅ Success: Reset to default icon")
                    }
                }
            }

            Text("Current icon: \(UIApplication.shared.alternateIconName ?? "Default")")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
