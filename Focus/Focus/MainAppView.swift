//
//  MainAppView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/9/25.
//
import SwiftUI

struct MainAppView: View {
    @State var auth = AuthViewModel()
    
    var body: some View {
        WithSettingsOverlay{
            FocusListView()
        }
    }
}

#Preview {
    MainAppView()
        .modelContainer(for: Item.self, inMemory: true)
}
