//
//  AppUser.swift
//  AI Notes
//
//  Created by mucayid on 2025-09-11.
//

import SwiftData
import Foundation

@Model
final class AppUser {
    @Attribute(.unique) var id: UUID
    var name: String
    @Attribute(.unique) var email: String
    var password: String
    var createdDate: Date

    init(id: UUID = UUID(),
         name: String,
         email: String,
         password: String,
         createdDate: Date = .now) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.createdDate = createdDate
    }
}
