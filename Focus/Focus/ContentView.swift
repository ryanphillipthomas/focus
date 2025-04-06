import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FocusListView()
                .tabItem {
                    Label("Focus", systemImage: "target")
                }

            AiView()
                .tabItem {
                    Label("Ai", systemImage: "brain")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
