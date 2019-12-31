//
//  RestaurantListTableViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/24/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit

struct RestaurantInfo {
    let title: String
    let info: String?
}

struct CellData {
    let image : UIImage?
    let message : RestaurantInfo?
}

class RestaurantListCollectionViewController: UITableViewController, UISearchResultsUpdating {
    var resultSearchController = UISearchController()
    var availableRestaurants = [Restaurant]()
    var filteredRestaurants = [Restaurant]()
    
    var restaurants: Restaurants! {
        get {
            let tabBar = self.tabBarController! as! ClientTabBarController
            return tabBar.restaurants
        } set {
            let tabBar = self.tabBarController! as! ClientTabBarController
            tabBar.restaurants = newValue
        }
    }
    
    var currentUser: User! {
        get {
            let tabBar = self.tabBarController! as! ClientTabBarController
            return tabBar.currentUser
        } set {
            let tabBar = self.tabBarController! as! ClientTabBarController
            tabBar.currentUser = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (resultSearchController.isActive) {
            return filteredRestaurants.count
        } else {
            return availableRestaurants.count
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailView", sender: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantCell
        cell.layoutSubviews()

        if (resultSearchController.isActive) {
            cell.message = RestaurantInfo(title: filteredRestaurants[indexPath.row].name, info: filteredRestaurants[indexPath.row].location)
            cell.logoImage.loadImageUsingCacheWithUrlString(urlString: filteredRestaurants[indexPath.row].logoImageUrl)
            return cell
        }
        else {
            cell.message = RestaurantInfo(title: availableRestaurants[indexPath.row].name, info: availableRestaurants[indexPath.row].location)
            cell.logoImage.loadImageUsingCacheWithUrlString(urlString: availableRestaurants[indexPath.row].logoImageUrl)
            return cell
        }
    }
}

extension RestaurantListCollectionViewController {
    func updateSearchResults(for searchController: UISearchController) {
        filteredRestaurants.removeAll(keepingCapacity: false)
        
        let filteredItems = availableRestaurants.filter { (restaurant) -> Bool in
            let name = restaurant.name.lowercased()
            return (name.contains(searchController.searchBar.text!.lowercased()))
        }
        
        filteredRestaurants = filteredItems
        self.tableView.reloadData()
    }
    
    func setupSearch() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.hidesNavigationBarDuringPresentation = false
            
            controller.searchBar.placeholder = "Find your restaurant!"
            tableView.tableHeaderView = controller.searchBar

            return controller
        })()
    }
    
    func configureTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.separatorStyle = .none
        self.navigationItem.title = "Available Restaurants"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 25)!]
        
        setupSearch()
        fetchRestaurants()
        tableView.reloadData()
    }
    
    func fetchRestaurants() {
        restaurants.fetchRestaurants { (err) in
            if (err != nil) {
                self.alert(message: err!.localizedDescription)
            } else {
                self.availableRestaurants = self.restaurants.availableRestaurants
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailView" {
            if let restaurantDetailViewController = segue.destination as? MenuViewController {
                let indexPath = tableView.indexPathForSelectedRow!.row
                if (resultSearchController.isActive) {
                    restaurantDetailViewController.restaurant = filteredRestaurants[indexPath]
                } else {
                    restaurantDetailViewController.restaurant = availableRestaurants[indexPath]
                }
            }
        }
    }
}
