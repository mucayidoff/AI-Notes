//
//  ModelContainer.swift
//  AI Notes
//
//  Created by mucayid on 2025-09-11.
//

import SwiftData
import Foundation

extension ModelContainer {
    static let shared: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: AppUser.self, Note.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
            return container
        } catch {
            fatalError("ModelContainer oluşturulamadı: \(error)")
        }
    }()
}
