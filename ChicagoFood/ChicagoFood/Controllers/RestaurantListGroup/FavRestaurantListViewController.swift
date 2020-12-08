//
//  FavRestaurantListViewController.swift
//  ChicagoFood
//
//  Created by 鄭雅涵 on 2020/11/12.
//

import UIKit
import CoreData
import Foundation

class FavRestaurantListViewController: UIViewController {
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var favTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var favLst: [FavRestaurant]?
    var restaurantService: RestaurantService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingSpinner.startAnimating()
        self.favTableView.dataSource = self
        self.favTableView.delegate = self
    }
    
    func fetchFavRestaurant() {
        do {
            self.favLst = try self.context.fetch(FavRestaurant.fetchRequest()) as? [FavRestaurant]
            DispatchQueue.main.async {
                self.favTableView.reloadData()
            }
        } catch {
            print("fail to fetch")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavRestaurant()
        self.loadingSpinner.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [self] in
            if self.favLst?.count == 0 {
                self.loadingSpinner.stopAnimating()
                let alert = UIAlertController(title: "Empty list!", message: "No favorite restaurant added.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default))
                
                self.present(alert, animated: true)
                
                let image = UIImage(named: "noFavorite.jpg")
                let imageView = UIImageView()
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageView.center = self.favTableView.center
                self.favTableView.backgroundColor = .white
                self.favTableView.separatorStyle = .none
                self.favTableView.backgroundView = imageView

                self.loadingSpinner.stopAnimating()
            } else {
                self.favTableView.backgroundView = .none
            }
        }
        self.loadingSpinner.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? DetailViewController,
            let selectedIndexPath = self.favTableView.indexPathForSelectedRow,
            let confirmedCell = self.favTableView.cellForRow(at: selectedIndexPath) as? RestaurantCell
            else { return }

        let confirmedRestaurant = confirmedCell.restaurant
        destination.restaurant = confirmedRestaurant
    }
}

extension FavRestaurantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favLst?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.favTableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantCell

        let currentRestaurant = self.favLst?[indexPath.row]

        let newFav = Restaurant(named: String(currentRestaurant!.name!), address: String(currentRestaurant!.address!), zip: Int(currentRestaurant!.zip), inspectionDate: String(currentRestaurant!.inspectionDate!), results: String(currentRestaurant!.results!), imageUrl: String(currentRestaurant!.imageUrl!))
        
        cell.restaurant = newFav

        return cell
    }
}

extension FavRestaurantListViewController: UITableViewDelegate {
    //MARK: Delegete
    func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "delete") {
            (action, view, completion) in
            
            
            if let cell = self.favTableView.cellForRow(at: indexPath) as? RestaurantCell,
               let confirmedRestaurant = cell.restaurant
            {
                self.deleteRestaurant(restaurant: confirmedRestaurant, deleteIndex: indexPath.row)
                self.favTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            completion(true)
        }
        action.backgroundColor = .red
        return action
    }
    
    func deleteRestaurant(restaurant: Restaurant, deleteIndex: Int) {
        if self.context != nil {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavRestaurant")
            fetchRequest.predicate = NSPredicate(format: "name = %@ AND address = %@", restaurant.name, restaurant.address)
            do {
                let results = try self.context.fetch(fetchRequest)
                if results.count == 1 {
                    self.context.delete(results[0] as! NSManagedObject)
                    do {
                        try self.context.save()
                    } catch {
                      print("Failed deleting")
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }

        self.favLst?.remove(at: deleteIndex)
        do {
            try self.context.save()
        } catch {
          print("Failed deleting")
        }
        self.fetchFavRestaurant()
    }
    
    func showEmptyListMessage(_ message:String) {
        //let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 40, height: 20))
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        //messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()
        
        self.view.addSubview(messageLabel)
        self.view.bringSubviewToFront(messageLabel)
    }
}

