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
    
     var currentUser: User! {
           get {
               let tabBar = self.tabBarController! as! ClientTabBarController
               return tabBar.currentUser
           } set {
               let tabBar = self.tabBarController! as! ClientTabBarController
               tabBar.currentUser = newValue
           }
       }
    
    var menuItems = [MenuItem]()
    
    var users = Users()
    var favouriteButtonActive = false
    
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureFavouriteButton()
    }
    
    func configureFavouriteButton() {
        if (self.currentUser.favouriteRestaurants.contains(restaurant.uid)) {
            self.favouriteButtonActive = true
            self.favouriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            self.favouriteButtonActive = false
            self.favouriteButton.image = UIImage(systemName: "heart")
        }
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
            unfavouriteRestaurant()
            favouriteButton.image = UIImage(systemName: "heart")
        } else {
            favouriteRestaurant()
            favouriteButton.image = UIImage(systemName: "heart.fill")
        }
        favouriteButtonActive = !favouriteButtonActive
    }
    
    func favouriteRestaurant() {
        self.currentUser!.favouriteRestaurant(restaurant: self.restaurant) { (err) in
            if err != nil {
                self.alert(message: err!.localizedDescription)
            } else {
                self.alert(message: "Restaurant Successfuly favourited")
                self.collectionView.reloadData()
            }
        }
    }

    func unfavouriteRestaurant() {
        self.currentUser!.unfavouriteRestaurant(restaurant: self.restaurant) { (err) in
             if err != nil {
                 self.alert(message: err!.localizedDescription)
             } else {
                self.alert(message: "Restaurant removed from favourites")
                self.collectionView.reloadData()
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
}