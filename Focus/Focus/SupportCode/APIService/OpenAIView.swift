//
//  OpenAIView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


import SwiftUI

struct OpenAIView: View {
    @StateObject private var viewModel = OpenAIViewModel()
    @State private var showLogs = false

    var body: some View {
        VStack(spacing: 0) {
            List(viewModel.messages) { message in
                HStack(alignment: .top) {
                    if message.role == "user" {
                        Spacer()
                        Text(message.content)
                            .padding(10)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                            .frame(maxWidth: 250, alignment: .trailing)
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(.init(message.content)) // markdown support
                                .font(.body)
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .frame(maxWidth: 250, alignment: .leading)
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)

            Divider()

            HStack {
                TextField("Type a message...", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)

                Button {
                    Task { await viewModel.send() }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "paperplane.fill")
                    }
                }
                .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
            }
            .padding()

            Button {
                showLogs = true
            } label: {
                Label("View Logs", systemImage: "doc.text.magnifyingglass")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .padding(.bottom)
        }
        .navigationTitle("Chat")
        .navigationDestination(isPresented: $showLogs) {
            InAppLogViewer(provider: "API")
        }
    }
}
