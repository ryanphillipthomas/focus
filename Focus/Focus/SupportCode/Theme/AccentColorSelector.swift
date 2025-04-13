//
//  AccentColorSelector.swift
//  Focus
//
//  Created by Ryan Thomas on 4/12/25.
//


import SwiftUI

struct AccentColorSelector: View {
    @AppStorage("accentColorName") var accentColorName: String = AccentColorOption.orange.rawValue
    @AppStorage("customAccentColorHex") var customAccentColorHex: String = "#FF6F61"

    @State private var customAccentColor: Color = Color(hex: "#FF6F61")
    @State private var selectedAccent: AccentColorOption? = AccentColorOption(rawValue: AccentColorOption.orange.rawValue)

    var body: some View {
        HStack(spacing: 16) {
            ForEach(AccentColorOption.allCases, id: \.self) { option in
                presetColorCircle(for: option)
            }
            customColorPicker()
        }
        .padding(.vertical, 8)
    }

    private func presetColorCircle(for option: AccentColorOption) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(option.color)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .strokeBorder(Color.primary, lineWidth: selectedAccent == option ? 3 : 0)
                )
                .onTapGesture {
                    accentColorName = option.rawValue
                    selectedAccent = option
                }
            Text(option.displayName)
                .font(.caption2)
        }
    }

    private func customColorPicker() -> some View {
        VStack(spacing: 4) {
            ColorPicker("", selection: $customAccentColor, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(Color.primary, lineWidth: selectedAccent == nil ? 3 : 0)
                )
                .onChange(of: customAccentColor) { newValue in
                    selectedAccent = nil
                    accentColorName = "custom"
                    customAccentColorHex = newValue.toHex()
                }

            Text("Custom")
                .font(.caption2)
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        scanner.scanString("#", into: nil)
        scanner.scanHexInt64(&hexNumber)

        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255

        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0]
        let r = Int((components.count > 0 ? components[0] : 0) * 255)
        let g = Int((components.count > 1 ? components[1] : 0) * 255)
        let b = Int((components.count > 2 ? components[2] : 0) * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

