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
       
   var restaurants = Restaurants()
   var availableRestaurants = [Restaurant]()
   var filteredRestaurants = [Restaurant]()
   var users = Users()
    var currentUser: User!
    
       override func viewDidLoad() {
           super.viewDidLoad()
            navigationItem.title = "Favorite Restaurants"
        configureTableView()
       }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchRestaurants()
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
               cell.mainImageView.loadImageUsingCacheWithUrlString(urlString: filteredRestaurants[indexPath.row].logoImageUrl)
               return cell
           }
           else {
               cell.message = RestaurantInfo(title: availableRestaurants[indexPath.row].name, info: availableRestaurants[indexPath.row].location)
               cell.mainImageView.loadImageUsingCacheWithUrlString(urlString: availableRestaurants[indexPath.row].logoImageUrl)
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

            tableView.tableHeaderView = controller.searchBar

            return controller
        })()
    }
    
    func configureTableView() {
        self.tableView.register(RestaurantCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        self.tableView.separatorStyle = .none
        
        setupSearch()
        fetchCurrentUser()
        tableView.reloadData()
    }
    
    func fetchCurrentUser() {
        startLoading()
        let currentUser = Auth.auth().currentUser!
        users.findUser(withId: currentUser.uid) { (user, err) in
            if err != nil {
                self.alert(message: err!.localizedDescription)
            } else {
                self.currentUser = user!
                self.fetchRestaurants()
            }
        }
    }
    
    func fetchRestaurants() {
        restaurants.fetchRestaurants { (err) in
            if (err != nil) {
                self.alert(message: err!.localizedDescription)
            } else {
                self.getFavouriteRestaurants()
            }
        }
    }
    
    func getFavouriteRestaurants() {
        if(self.presentedViewController != nil) {
            dismiss(animated: false) {
                self.filterForFavouriteRestaurants()
            }
        } else {
            self.filterForFavouriteRestaurants()
        }
    }
    
    func filterForFavouriteRestaurants() {
        print(self.restaurants.availableRestaurants)
        if let favRests = self.currentUser!.favouriteRestaurants {
            self.availableRestaurants = self.restaurants.favouriteRestaurants(favouriteRestaurantIds: favRests)
            self.tableView.reloadData()
        } else {
            self.availableRestaurants = []
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailView" {
            if let restaurantDetailViewController = segue.destination as? RestaurantDetailCollectionViewController {
                let indexPath = tableView.indexPathForSelectedRow!.row
                if (resultSearchController.isActive) {
                    restaurantDetailViewController.restaurant = filteredRestaurants[indexPath]
                    restaurantDetailViewController.restaurants = self.restaurants
                } else {
                    restaurantDetailViewController.restaurant = availableRestaurants[indexPath]
                }
            }
        }
    }
}
