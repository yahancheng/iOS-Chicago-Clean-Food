//
//  RestaurantTest.swift
//  ChicagoFoodTests
//
//  Created by 鄭雅涵 on 2020/10/22.
//

import XCTest
@testable import ChicagoFood

class RestaurantTest: XCTestCase {

    func testRestaurantDebugAddress() {
        //Given
        let subjectUnderTest = Restaurant(
            named: "Yummy restaurant",
            address: "61st ST",
            zip: 60637,
            inspectionDate: "2020/09/16",
            results: "pass",
            imageUrl: "https://images.app.goo.gl/XG5ERkWXrh4BpFTw8")
        
        //When
        let actualValue = subjectUnderTest.debugDescription

        //Then
        let expectedValue = "Restaurant(name: Yummy restaurant, address: 61st ST)"
        XCTAssertEqual(actualValue, expectedValue)

    }

}
