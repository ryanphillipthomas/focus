import SwiftUI

struct ContentView: View {
    @State var auth = AuthViewModel()

    var body: some View {
        Group {
            if auth.user != nil {
                MainAppView(auth: auth)
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
