//
//  MindDumpView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//


import SwiftUI
import SwiftData

struct MindDumpView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskItem.createdAt, order: .reverse) private var tasks: [TaskItem]

    @State private var newTaskTitle = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("What's on your mind?", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()

                List {
                    ForEach(tasks) { task in
                        Text(task.title)
                    }
                    .onDelete(perform: deleteTasks)
                }
            }
            .navigationTitle("Mind Dump")
        }
    }

    private func addTask() {
        let trimmed = newTaskTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        let newTask = TaskItem(title: trimmed)
        context.insert(newTask)
        newTaskTitle = ""
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            context.delete(tasks[index])
        }
    }
}
