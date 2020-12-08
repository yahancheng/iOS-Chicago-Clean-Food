//
//  DetailViewController.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/10/16.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    @IBOutlet var detailView: UIView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    var restaurant: Restaurant!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantNameLabel.text = self.restaurant.name
        
        DispatchQueue.global(qos: .userInitiated).async {
            let restaurantImagaData = NSData(contentsOf: URL(string: self.restaurant!.imageUrl)!)
            
            if let confirmedRestaurantData = restaurantImagaData {
                DispatchQueue.main.async {
                    self.restaurantImageView.image = UIImage(data: confirmedRestaurantData as Data)
                }
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoSegueIdentifier" {
            if let infoDestination = segue.destination as? ChildInfoViewController  {
                infoDestination.restaurant = self.restaurant
            }
        }
        if segue.identifier == "mapSegueIdentifier" {
            if let mapDestination = segue.destination as? ChildMapViewController  {
                mapDestination.restaurant = self.restaurant
            }
        }
    }
    
    
    
    @IBAction func didChangeSegmentControlValue( _ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // info
            self.infoContainerView.isHidden = false
            self.mapContainerView.isHidden = true
        }
        else {
            self.infoContainerView.isHidden = true
            self.mapContainerView.isHidden = false

        }
    }
    
}
