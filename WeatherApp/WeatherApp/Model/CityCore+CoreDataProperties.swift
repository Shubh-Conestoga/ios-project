//
//  CityCore+CoreDataProperties.swift
//  WeatherApp
//
//  Created by user193659 on 12/2/21.
//
//

import Foundation
import CoreData


extension CityCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityCore> {
        return NSFetchRequest<CityCore>(entityName: "CityCore")
    }

    @NSManaged public var lat: Double
    @NSManaged public var log: Double
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var temp: Double

}

extension CityCore : Identifiable {

}
