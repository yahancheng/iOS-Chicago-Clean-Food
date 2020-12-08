//
//  FavRestaurant+CoreDataProperties.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/11/16.
//
//

import Foundation
import CoreData


extension FavRestaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavRestaurant> {
        return NSFetchRequest<FavRestaurant>(entityName: "FavRestaurant")
    }

    @NSManaged public var address: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var inspectionDate: String?
    @NSManaged public var name: String?
    @NSManaged public var results: String?
    @NSManaged public var zip: Int64

}

extension FavRestaurant : Identifiable {

}
