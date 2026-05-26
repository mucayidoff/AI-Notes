//
//  AppUser+CoreDataProperties.swift
//  AI Notes
//
//  Created by mucayid on 2025-07-20.
//
//

import Foundation
import CoreData


extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser")
    }

    @NSManaged public var content: String?
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var reatedDate: Date?
    @NSManaged public var summary: String?
    @NSManaged public var tag: String?
    @NSManaged public var title: String?

}

extension AppUser : Identifiable {

}
