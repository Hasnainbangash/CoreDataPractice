//
//  Person+CoreDataProperties.swift
//  CoreDataPractice
//
//  Created by Elexoft on 10/12/2024.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int64
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNo: Int64

}

extension Person : Identifiable {

}
