//
//  User+CoreDataProperties.swift
//  
//
//  Created by Techno-MAC on 13/06/19.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var workDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var id: String?

}
