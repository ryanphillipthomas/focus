import SwiftUI

struct ContentView: View {
    @State var auth = AuthViewModel()

    var body: some View {
        WithSettingsOverlay(contextualSettings: contextualOptions) {
            if auth.user != nil {
                FocusListView()
            } else {
                AuthView(auth: auth)
            }
        }
    }
    
    var contextualOptions: [ContextualSetting] {
        [
            ContextualSetting(
                title: "Login as Test Account",
                systemImage: "person.crop.circle",
                action: {
                    Task {
                        await auth.signIn(email: "ryanphillipthomas@gmail.com", password: "12171217")
                    }
                }
            ),
            ContextualSetting(
                title: "Login as Test Account 2",
                systemImage: "person.crop.circle.fill",
                action: {
                    Task {
                        await auth.signIn(email: "ryanphillipthomas@gmail.com", password: "12171217")
                    }
                }
            )
        ]
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
