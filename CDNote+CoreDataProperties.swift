//
//  CDNote+CoreDataProperties.swift
//  AI Notes
//
//  Created by mucayid on 2025-07-20.
//
//

import Foundation
import CoreData



extension CDNote {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNote> {
        return NSFetchRequest<CDNote>(entityName: "CDNote")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var summary: String?
    @NSManaged public var content: String?
    @NSManaged public var tag: String?
    @NSManaged public var createdDate: Date?
}

extension CDNote: Identifiable {

}

