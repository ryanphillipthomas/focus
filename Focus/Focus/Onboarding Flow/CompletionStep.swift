//
//  CompletionStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
// Completion Step
struct CompletionStep: View {
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("You're all set!").font(.largeTitle.bold())
            Text("Let’s plan your first focus block")
            Spacer()
            Button("Start Planning") {
                // Navigate to main app
                onDone()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
