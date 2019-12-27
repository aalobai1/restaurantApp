//
//  RestaurantTableViewControllerExtensions.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/26/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import Foundation
import UIKit

extension RestaurantListTableViewController {
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
