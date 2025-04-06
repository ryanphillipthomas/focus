//
//  AiView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//

import SwiftUI

struct AiView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("🤖 AI Tools Coming Soon")
                    .font(.title)
                    .fontWeight(.semibold)

                Text("This is where your intelligent features will live.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .navigationTitle("Ai")
        }
    }
}
