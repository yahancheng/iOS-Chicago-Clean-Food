//
//  RestaurantCell.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/10/2.
//

import UIKit

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantDescriptionLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    var restaurant: Restaurant? {
        didSet{
            self.restaurantNameLabel.text = restaurant?.name
            self.restaurantDescriptionLabel.text = restaurant?.address
            
            DispatchQueue.global(qos: .userInitiated).async {
                let restaurantImagaData = NSData(contentsOf: URL(string: self.restaurant!.imageUrl)!)
                
                if let confirmedRestaurantData = restaurantImagaData {
                DispatchQueue.main.async {
                    self.restaurantImageView.image = UIImage(data: confirmedRestaurantData as Data)
                    self.restaurantImageView.layer.cornerRadius = self.restaurantImageView.frame.width / 2
                }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
