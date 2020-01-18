//
//  FavouriteRestaurantsTableViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/27/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit
import Firebase

class FavouriteRestaurantsTableViewController: UITableViewController, UISearchResultsUpdating {
    var resultSearchController = UISearchController()
       
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
        }
        set {
            let tabBar = self.tabBarController! as! ClientTabBarController
            tabBar.currentUser = newValue
        }
    }
    
    var availableRestaurants = [Restaurant]()
    var filteredRestaurants = [Restaurant]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func refresh(sender:AnyObject) {
        filterForFavouriteRestaurants()
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        filterForFavouriteRestaurants()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultSearchController.dismiss(animated: false, completion: nil)
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

extension FavouriteRestaurantsTableViewController {
    func updateSearchResults(for searchController: UISearchController) {
        filteredRestaurants.removeAll(keepingCapacity: false)
        
        let filteredItems = availableRestaurants.filter { (restaurant) -> Bool in
            return (restaurant.name.contains(searchController.searchBar.text!))
        }
        
        filteredRestaurants = filteredItems
        self.tableView.reloadData()
    }
    
    func setupSearch() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            
            controller.searchBar.searchBarStyle = .default
            controller.obscuresBackgroundDuringPresentation = false
            
            controller.searchBar.setTextField(color: UIColor.white)
            controller.searchBar.set(textColor: UIColor.black)
            controller.searchBar.setSearchImage(color: UIColor.black)
            
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.placeholder = "Find a restaurant!"
            controller.searchBar.isTranslucent = false
            
            tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    func configureTableView() {
        tableView.rowHeight = 110
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        
        navigationItem.title = "Favorite Restaurants"
        navigationController?.navigationBar.layer.borderWidth = 0.0
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 25)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        
        
        setupSearch()
        tableView.reloadData()
    }
    
    func filterForFavouriteRestaurants() {
        if (!currentUser.favouriteRestaurants.isEmpty) {
            self.availableRestaurants = self.restaurants.filterForRestaurants(favouriteRestaurantIds: currentUser.favouriteRestaurants)
            self.tableView.reloadData()
        } else {
            self.availableRestaurants = []
            self.tableView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        resultSearchController.searchBar.resignFirstResponder()
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
