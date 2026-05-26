//
//  Note.swift
//  AI Notes
//
//  Created by mucayid on 2025-09-11.
//

import Foundation
import SwiftData

@Model
final class Note {
    @Attribute(.unique) var id: UUID
    var title: String
    var summary: String
    var content: String
    var tag: String
    var createdDate: Date
    var updatedDate: Date?

    init(id: UUID = UUID(),
         title: String,
         summary: String,
         content: String,
         tag: String,
         createdDate: Date = .now,
         updatedDate: Date? = nil) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.tag = tag
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
}
