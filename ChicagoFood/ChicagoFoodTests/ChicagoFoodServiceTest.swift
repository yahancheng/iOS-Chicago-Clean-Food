//
//  RestaurantServiceTest.swift
//  ChicagoFoodTests
//
//  Created by 鄭雅涵 on 2020/10/22.
//

import XCTest
@testable import ChicagoFood
//command + U: build test and run

class RestaurantServiceTest: XCTestCase {
    var systemUnderTest: RestaurantService!


    override func setUpWithError() throws {
        self.systemUnderTest = RestaurantService()
    }

    override func tearDownWithError() throws {
        self.systemUnderTest = nil
    }

    func testAPI_returnSuccessfukResult() throws {
        //Given
        var restaurants: [Restaurant]!
        var error: Error?
        
        let promise = expectation(description: "Completion handle is invoked")
        
        //When
        self.systemUnderTest.getRestaurants(completion: { data, shouldntHappend in
            restaurants = data
            error = shouldntHappend
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        
        //Then
        XCTAssertNotNil(restaurants)
        XCTAssertNil(error)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
