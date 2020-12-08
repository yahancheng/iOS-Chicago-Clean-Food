//
//  ChildMapViewController.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/11/24.
//

import UIKit
import MapKit

class ChildMapViewController: UIViewController {
    @IBOutlet weak var restaurantMapView: MKMapView!
    
    var restaurant: Restaurant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geoCodeAddress(address: restaurant!.address + ", Chicago" as NSString)
    }
    
    private func geoCodeAddress(address:NSString){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address as String, completionHandler: { placemarks, error in
            if (error != nil) {
                return
            }
            if let placemark = placemarks?[0]  {
                
                let location = CLLocationCoordinate2D(
                    latitude: placemark.location?.coordinate.latitude ?? 0.0,
                    longitude: placemark.location?.coordinate.longitude ?? 0.0)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let zoomRegion = MKCoordinateRegion(center: location, span: span)
                self.restaurantMapView.setRegion(zoomRegion, animated: true)
                self.restaurantMapView.addAnnotation(MKPlacemark(placemark: placemark))
                
            }
        })}

}
