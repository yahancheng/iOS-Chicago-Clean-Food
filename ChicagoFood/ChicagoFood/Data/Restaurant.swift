//
//  File.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/10/10.
//  Icon from: https://www.flaticon.com/

import Foundation
class Restaurant: CustomDebugStringConvertible, Codable {
    var debugDescription: String {
        return "Restaurant(name: \(self.name), address: \(self.address))"
    }
    
    var name: String
    var address: String
    var zip: Int
    var inspectionDate: String
    var results: String
    var imageUrl: String

    var isFavorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case name, address, zip, inspectionDate, results, imageUrl
    }
    
    init(named name: String, address: String, zip: Int, inspectionDate: String, results: String, imageUrl: String) {
        self.name = name
        self.address = address
        self.zip = zip
        self.inspectionDate = inspectionDate
        self.results = results
        self.imageUrl = imageUrl
    }
}


struct RestaurantResult: Codable {
    let restaurants: [Restaurant]
}
