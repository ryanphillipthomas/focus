import SwiftUI

struct ThemeSelectionView: View {
    @AppStorage("accentColorName") var accentColorName: String = AccentColorOption.orange.rawValue
    @AppStorage("customAccentColorHex") var customAccentColorHex: String = "#FF6F61"

    @State private var customAccentColor: Color = Color(hex: "#FF6F61")
    @State private var selectedAccent: AccentColorOption? = AccentColorOption(rawValue: AccentColorOption.orange.rawValue)

    @State private var currentAppIcon: AppIcon = {
        let current = UIApplication.shared.alternateIconName
        return AppIcon.allCases.first(where: { $0.iconName == current }) ?? .default
    }()

    private var selectedAccentColor: Color {
        selectedAccent?.color ?? Color(hex: customAccentColorHex)
    }

    var body: some View {
        Form {
            // Accent Color Picker
            Section(header: Text("Accent Color")) {
                AccentColorSelectorView()
            }

            // App Icon Picker
            Section(header: Text("App Icon")) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 16)]) {
                    ForEach(AppIcon.allCases, id: \.self) { icon in
                        AppIconTileView(icon: icon,
                                    isSelected: currentAppIcon == icon,
                                    selectedColor: selectedAccentColor) {
                            changeAppIcon(to: icon)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Customize")
        .accentColor(selectedAccentColor)
        .analyticsScreen(self)
    }

    private func changeAppIcon(to icon: AppIcon) {
        print("Attempting to change to icon: \(icon.iconName ?? "default")")
        guard UIApplication.shared.supportsAlternateIcons else { return }

        UIApplication.shared.setAlternateIconName(icon.iconName) { error in
            if let error = error {
                print("❌ Failed to change app icon: \(error.localizedDescription)")
            } else {
                print("✅ Changed to icon: \(icon.iconName ?? "default")")
                currentAppIcon = icon
            }
        }
    }
}
