import SwiftUI

struct CustomizationView: View {
    @AppStorage("accentColorName") private var accentColorName: String = AccentColorOption.blue.rawValue
    
    @State private var currentAppIcon: AppIcon = {
        let current = UIApplication.shared.alternateIconName
        return AppIcon.allCases.first(where: { $0.iconName == current }) ?? .default
    }()

    private var selectedAccent: AccentColorOption {
        AccentColorOption(rawValue: accentColorName) ?? .blue
    }

    var body: some View {
        Form {
            // Accent Color Selection
            Section(header: Text("Accent Color")) {
                HStack(spacing: 16) {
                    ForEach(AccentColorOption.allCases, id: \.self) { option in
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
                                }
                            Text(option.displayName)
                                .font(.caption2)
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            // App Icon Selection
            Section(header: Text("App Icon")) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 16)]) {
                    ForEach(AppIcon.allCases, id: \.self) { icon in
                        VStack(spacing: 6) {
                            Image(uiImage: UIImage(named: icon.previewName) ?? UIImage())
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(selectedAccent.color, lineWidth: currentAppIcon == icon ? 3 : 0)
                                )
                                .onTapGesture {
                                    changeAppIcon(to: icon)
                                }

                            Text(icon.displayName)
                                .font(.caption2)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .accentColor(selectedAccent.color)
        .navigationTitle("Customize")
        .analyticsScreen(self)
    }

    private func changeAppIcon(to icon: AppIcon) {
        print("Attempting to change to icon: \(icon.iconName ?? "default")")
        guard UIApplication.shared.supportsAlternateIcons else { return }
            UIApplication.shared.setAlternateIconName(icon.iconName) { error in
                print("Attempting to change to icon: \(icon.iconName ?? "default")")
                if let error = error {
                    print("Failed to change app icon: \(error.localizedDescription)")
                } else {
                    print("Changed to icon: \(icon.iconName ?? "default")")
                    currentAppIcon = icon
                }
            }
        }
}
