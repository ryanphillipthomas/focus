import SwiftUI

struct AnalyticsScreenView: ViewModifier {
    let screenName: String

    init<V: View>(_ view: V) {
        let rawName = String(describing: type(of: view))
        self.screenName = AnalyticsScreenView.formatScreenName(rawName)
    }

    func body(content: Content) -> some View {
        content.onAppear {
            AnalyticsManager.shared.logScreen(screenName)
        }
    }

    static func formatScreenName(_ name: String) -> String {
        name.replacingOccurrences(
            of: "([a-z])([A-Z])",
            with: "$1 $2",
            options: .regularExpression
        )
    }
}

extension View {
    func analyticsScreen(_ view: some View) -> some View {
        self.modifier(AnalyticsScreenView(view))
    }
}
