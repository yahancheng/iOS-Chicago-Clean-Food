//
//  RestaurantService.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/10/10.
//

import Foundation
import UIKit.UIAlertController

enum RestaurantCallingError: Error {
    case problemGeneratingURL
    case problemGettingDataFromAPI
    case problemDecodingData
}

class RestaurantService {

    private let urlString =
        "https://run.mocky.io/v3/e8f3b4d8-b6e5-465b-94ed-c404ff8d4957"
    
    func getRestaurants(completion: @escaping ([Restaurant]?, Error?) -> ()) {
            guard let url = URL(string: self.urlString) else {
                DispatchQueue.main.async { completion(nil, RestaurantCallingError.problemGeneratingURL) }
                return
        }
    
                
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async { completion(nil, RestaurantCallingError.problemGettingDataFromAPI) }
                    return
                }
                
                do {
                    let restaurantResult = try JSONDecoder().decode(RestaurantResult.self, from: data)
                    DispatchQueue.main.async { completion(restaurantResult.restaurants, nil) }
                } catch (let error) {
                    print(error)
                    DispatchQueue.main.async { completion(nil, RestaurantCallingError.problemDecodingData) }
                }
                                                        
            }
            task.resume()
        }
    
}
