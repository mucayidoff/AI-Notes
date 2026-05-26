//
//  TaskItem.swift
//  AI Notes
//
//  Created by mucayid on 2025-04-12.
//

import Foundation

struct TaskItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdDate: Date

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdDate = createdDate
    }

    static let example = TaskItem(title: "Örnek Görev")
}
