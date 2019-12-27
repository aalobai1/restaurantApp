//
//  RestaurantDetailViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/26/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit
import Firebase

class RestaurantDetailCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var restaurant: Restaurant!
    var restaurants: Restaurants!
    var menuItems = [MenuItem]()
    var users = Users()
    var favouriteButtonActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuItemCell
        cell.menuItemTitle = menuItems[indexPath.row].name
        cell.menuItemDescription = menuItems[indexPath.row].description
        cell.thumbnailImageView.loadImageUsingCacheWithUrlString(urlString: menuItems[indexPath.row].imageUrl)
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIBarButtonItem) {
        if favouriteButtonActive {
            favouriteRestaurant()
        } else {
            unfavouriteRestaurant()
        }
        favouriteButtonActive = !favouriteButtonActive
    }
    
    func favouriteRestaurant() {
        let currentUser = Auth.auth().currentUser
        users.findUser(withId: currentUser!.uid) { (user, err) in
            if err != nil {
                self.alert(message: err!.localizedDescription)
            } else {
                user!.favouriteRestaurant(restaurant: self.restaurant) { (err) in
                    if err != nil {
                        self.alert(message: err!.localizedDescription)
                    } else {
                        self.alert(message: "Restaurant Successfuly favourited")
                    }
                }
            }
        }
    }

    func unfavouriteRestaurant() {
        let currentUser = Auth.auth().currentUser
        users.findUser(withId: currentUser!.uid) { (user, err) in
            if err != nil {
                self.alert(message: err!.localizedDescription)
            } else {
                user!.favouriteRestaurant(restaurant: self.restaurant) { (err) in
                    if err != nil {
                        self.alert(message: err!.localizedDescription)
                    } else {
                        self.alert(message: "Restaurant Successfuly favourited")
                    }
                }
            }
        }
    }
}



extension RestaurantDetailCollectionViewController {
    func configureNavigationBar() {
        navigationItem.title = restaurant.name
        collectionView.backgroundColor = UIColor.white
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: "Cell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    
    func configureCollectionView() {
        configureNavigationBar()
        fetchMenuItems()
        collectionView.reloadData()
    }
    
    func fetchMenuItems() {
        restaurant.fetchMenu { (err) in
            if err != nil {
                self.alert(message: err!.localizedDescription)
            } else {
                self.menuItems = self.restaurant.menu!.menuItems
                self.collectionView.reloadData()
            }
        }
    }
    
    func currentRestaurantFavourited() {
    }
}
