//
//  TaskView.swift
//  AI Notes
//
//  Created by mucayid on 2025-04-12.
//

// Views/TaskView.swift

import SwiftUI

struct TaskView: View {
    @State private var tasks: [String] = []
    @State private var newTask = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("tasks_header")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            HStack {
                TextField("new_task_placeholder", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: addTask) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .accessibilityLabel("add_task")
                .disabled(newTask.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)

            if tasks.isEmpty {
                Text("no_tasks")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(tasks, id: \.self) { task in
                        Text(task)
                    }
                    .onDelete(perform: deleteTask)
                }
            }

            Spacer()
        }
        .padding(.top)
        .navigationTitle("tasks_title")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Fonksiyonlar

    private func addTask() {
        let trimmed = newTask.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        tasks.append(trimmed)
        newTask = ""
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}
#Preview {
    TaskView()
}
