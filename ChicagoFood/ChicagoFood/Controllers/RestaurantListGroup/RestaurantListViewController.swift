//
//  ViewController.swift
//  ChicagoFood
//
//  Created by yahancheng on 2020/10/2.
//


import UIKit
import CoreData

class RestaurantListViewController: UIViewController {
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    //never nil when it's accessed, or the app will crash (so set to empty list)
    var flock: [Restaurant] = []
    var restaurantService: RestaurantService!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingSpinner.startAnimating()

        // Do any additional setup after loading the view.
        self.restaurantService = RestaurantService()
        self.tableView.dataSource = self
        self.tableView.delegate = self

            }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let confirmedService = self.restaurantService else { return }
        
        confirmedService.getRestaurants(completion: { restaurants, error in
            guard let restaurants = restaurants, error == nil else {
                return
            }
            self.flock = restaurants
            self.tableView.reloadData()
        })
        self.loadingSpinner.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [self] in
            if self.flock.count == 0 {
                self.loadingSpinner.stopAnimating()
                let alert = UIAlertController(title: "Oops!", message: "No data available now, \nplease check your connection and refresh", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    self.loadData() }))
                alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: { action in
                    self.loadData() }))
                
                self.present(alert, animated: true)
                
                let image = UIImage(named: "noData.jpg")
                let imageView = UIImageView()
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageView.center = self.tableView.center
                self.tableView.backgroundColor = .white
                self.tableView.separatorStyle = .none
                self.tableView.backgroundView = imageView

                self.loadingSpinner.stopAnimating()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkThrough") {
            return
        }
        
        let storyboard = UIStoryboard(name:"Onboarding", bundle: nil)
        if let walkThroughViewController = storyboard.instantiateViewController(identifier: "WalkThroughViewController") as? WalkThroughViewController {
            present(walkThroughViewController, animated: true, completion: nil)
        }
    }
    
    @objc func loadData(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.loadingSpinner.startAnimating()
                self.viewWillAppear(true)
                }
            }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? DetailViewController,
            let selectedIndexPath = self.tableView.indexPathForSelectedRow,
            let confirmedCell = self.tableView.cellForRow(at: selectedIndexPath) as? RestaurantCell
            else { return }

        let confirmedRestaurant = confirmedCell.restaurant
        destination.restaurant = confirmedRestaurant
    }
}

extension RestaurantListViewController: UITableViewDataSource {
    //MARK: DataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flock.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantCell

        let currentRestaurant = self.flock[indexPath.row]
        
        cell.restaurant = currentRestaurant
   
        return cell
            
    }
}

extension RestaurantListViewController: UITableViewDelegate {
    //MARK: Delegete
    func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = favoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        let restaurant = flock[indexPath.row]
        
        
        let action = UIContextualAction(style: .normal, title: "Favorite") {
            (action, view, completion) in
            restaurant.isFavorite = !restaurant.isFavorite

            if let cell = self.tableView.cellForRow(at: indexPath) as? RestaurantCell,
               let confirmedRestaurant = cell.restaurant
            {
                let heart = UIImageView(frame: CGRect(x: 0, y: 65, width: 20, height: 20))
                heart.image = UIImage(systemName: "heart.fill")
                heart.tintColor = .systemRed
                cell.accessoryView = confirmedRestaurant.isFavorite ? heart : heart
                self.save(restaurant: confirmedRestaurant)
                
            }
            
            completion(true)

        }
        action.backgroundColor = .red
        
        return action
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
    
    func save(restaurant: Restaurant) {
        if self.context != nil {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavRestaurant")
            fetchRequest.predicate = NSPredicate(format: "name = %@ AND address = %@", restaurant.name, restaurant.address)
            do {
                let results = try self.context.fetch(fetchRequest)
                if results.count == 0 {
                    let entity =
                        NSEntityDescription.entity(forEntityName: "FavRestaurant",
                                                   in: self.context)!
                    
                    let newFav = NSManagedObject(entity: entity,
                                                 insertInto: self.context)
                      
                    newFav.setValue(restaurant.name, forKey: "name")
                    newFav.setValue(restaurant.address, forKey: "address")
                    newFav.setValue(restaurant.zip, forKey: "zip")
                    newFav.setValue(restaurant.imageUrl, forKey: "imageUrl")
                    newFav.setValue(restaurant.inspectionDate, forKey: "inspectionDate")
                    newFav.setValue(restaurant.results, forKey: "results")

                    do {
                        try self.context.save()
                    } catch {
                      print("Failed saving")
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
}

