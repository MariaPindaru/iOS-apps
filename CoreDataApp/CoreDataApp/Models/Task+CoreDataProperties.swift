//
//  Task+CoreDataProperties.swift
//  CoreDataApp
//
//  Created by Maria Pindaru on 30.05.2023.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var details: String?
    @NSManaged public var done: Bool
    @NSManaged public var group: Group?

}

extension Task : Identifiable {

}
