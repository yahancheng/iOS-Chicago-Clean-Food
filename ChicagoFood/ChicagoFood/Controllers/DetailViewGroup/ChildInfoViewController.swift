//
//  ChildInfoViewController.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/11/24.
//

import UIKit

class ChildInfoViewController: UIViewController {
    @IBOutlet weak var inspectionResultLabel: UILabel!
    @IBOutlet weak var restaurantZipLabel: UILabel!
    @IBOutlet weak var inspectionDateLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    
    
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restaurantAddressLabel.text = restaurant!.address
        self.restaurantZipLabel.text = String(restaurant!.zip)
        self.inspectionDateLabel.text = restaurant!.inspectionDate
        self.inspectionResultLabel.text = restaurant!.results
    }
    
}
