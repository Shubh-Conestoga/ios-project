//
//  Person+CoreDataProperties.swift
//  WeatherApp
//
//  Created by user199008 on 12/7/21.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var personId: Int64
    @NSManaged public var personName: String?
    @NSManaged public var personPassword: String?
    @NSManaged public var personEmail: String?

}

extension Person : Identifiable {

}
