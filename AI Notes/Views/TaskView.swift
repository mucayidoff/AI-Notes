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
            Text("📝 Görevler")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            HStack {
                TextField("Yeni görev ekle...", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: addTask) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .disabled(newTask.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)

            if tasks.isEmpty {
                Text("Henüz görev eklenmedi.")
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
        .navigationTitle("Görevler")
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
