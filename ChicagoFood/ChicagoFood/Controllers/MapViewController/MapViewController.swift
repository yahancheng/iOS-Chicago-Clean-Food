//
//  MapViewController.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/11/12.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var restaurants: [Restaurant] = []
    var restaurantService: RestaurantService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let center = CLLocationCoordinate2D(latitude: 41.89, longitude: -87.63)
        let zoomRegion = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(zoomRegion, animated: true)
        
        self.restaurantService = RestaurantService()
        guard let confirmedService = self.restaurantService else {
            return }
        confirmedService.getRestaurants(completion: { restaurants, error in
            guard let restaurants = restaurants, error == nil else {
                return
            }
            self.restaurants = restaurants
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.geoCodeAddress(restaurants: self.restaurants)
        }
    }
    
    private func geoCodeAddress(restaurants:[Restaurant]){
        
        for restaurant in restaurants {
            let chicagoAddress = restaurant.address + ", Chicago"
            let annotation = MKPointAnnotation()
            getCoordinates(chicagoAddress) {  loc in
                annotation.title = restaurant.name
                annotation.coordinate = loc
            }
            mapView.addAnnotation(annotation)
        }
    }
    func getCoordinates(_ address: String,completion:@escaping((CLLocationCoordinate2D) -> ())){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {  return }
            DispatchQueue.main.async {
                completion(location.coordinate)
            }
        }
    }
}

