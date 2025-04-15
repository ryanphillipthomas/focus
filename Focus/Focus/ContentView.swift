import SwiftUI

struct ContentView: View {
    @State var auth = AuthViewModel()

    var body: some View {
        WithSettingsOverlay(
            inlineContextualOptions: inlineContextualOptions,
            groupedContextualOptions: groupedContextualOptions
        ) {
            if auth.user != nil {
                FocusListView()
            } else {
                AuthView(auth: auth)
            }
        }
    }
    
    var inlineContextualOptions: [ContextualSetting] {
        [
            ContextualSetting(
                title: "Login as Test Account",
                systemImage: "person.crop.circle",
                action: {
                    Task {
                        await auth.signIn(email: "ryanphillipthomas@gmail.com", password: "12171217")
                    }
                }
            )
        ]
    }

    var groupedContextualOptions: [ContextualSetting] {
        [
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
