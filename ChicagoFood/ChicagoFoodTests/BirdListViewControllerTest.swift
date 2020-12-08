//
//  BirdListViewControllerTest.swift
//  ChicagoFoodTests
//
//  Created by 鄭雅涵 on 2020/10/22.
//

import XCTest
@testable import ChicagoFood


class BirdListViewControllerTest: XCTestCase {
    
    var systemUnderTest: BirdListViewController!

    override func setUpWithError() throws {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.systemUnderTest = navigationController.topViewController as? BirdListViewController
        
        UIApplication.shared.windows
            .filter { $0.isKeyWindow }
            .first!
            .rootViewController = self.systemUnderTest
        
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(self.systemUnderTest.view)
    }


    func testTableView_loadsRestaurants() throws {
        //Given
        let mockRestaurantService = MockRestaurantService()
        let mockRestaurants = [
            Restaurant(named: "Yummy restaurant",
                       address: "61st ST",
                       zip: 60637,
                       inspectionDate: "2020/09/16",
                       results: "pass",
                       imageUrl: "https://images.app.goo.gl/XG5ERkWXrh4BpFTw8"),
            Restaurant(named: "Delicious restaurant",
                       address: "57th ST",
                       zip: 60637,
                       inspectionDate: "2020/09/16",
                       results: "pass",
                       imageUrl: "https://images.app.goo.gl/XG5ERkWXrh4BpFTw8"),
            Restaurant(named: "Soso restaurant",
                       address: "51st ST",
                       zip: 60637,
                       inspectionDate: "2020/09/16",
                       results: "pass",
                       imageUrl: "https://images.app.goo.gl/XG5ERkWXrh4BpFTw8")
        ]
        
        mockRestaurantService.mockRestaurants = mockRestaurants
        
        self.systemUnderTest.viewDidLoad()
        self.systemUnderTest.restaurantService = mockRestaurantService
        
        XCTAssertEqual(0, self.systemUnderTest.tableView.numberOfRows(inSection: 0))
        
        //When
        self.systemUnderTest.viewWillAppear(false)
        
        //Then
        XCTAssertEqual(mockRestaurants.count, self.systemUnderTest.flock.count)
        XCTAssertEqual(mockRestaurants.count, self.systemUnderTest.tableView.numberOfRows(inSection: 0))
        
    }
    
    class MockRestaurantService: RestaurantService {
        var mockRestaurants: [Restaurant]?
        var mockError: Error?
        
        override func getRestaurants(completion: @escaping ([Restaurant]?, Error?) -> ()) {
            completion(mockRestaurants, mockError)
        }
    }

}
