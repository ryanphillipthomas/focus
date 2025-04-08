import SwiftUI

struct MindDumpView: View {
    @State private var currentAppIcon: AppIcon = {
        let current = UIApplication.shared.alternateIconName
        return AppIcon.allCases.first(where: { $0.iconName == current }) ?? .default
    }()

    var body: some View {
        ZStack {
            Image(currentAppIcon.previewName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}
