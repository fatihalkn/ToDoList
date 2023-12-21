//
//  ToDoListItem+CoreDataProperties.swift
//  ToList
//
//  Created by Fatih on 20.12.2023.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAd: Date?

}

extension ToDoListItem : Identifiable {

}
