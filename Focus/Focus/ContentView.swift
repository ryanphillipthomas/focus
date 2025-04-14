import SwiftUI

struct ContentView: View {
    @State var auth = AuthViewModel()

    var body: some View {
        WithSettingsOverlay{
            if auth.user != nil {
                FocusListView()
            } else {
                AuthView(auth: auth)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
