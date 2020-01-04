//
//  MenuViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/30/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit

class AdminMenuViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var navigationButtons: [UIButton]!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
     var currentUser: User! {
        get {
            let tabBar = self.tabBarController! as! AdminTabBarController
            return tabBar.currentUser
        } set {
            let tabBar = self.tabBarController! as! AdminTabBarController
            tabBar.currentUser = newValue
        }
    }
    
    var menuItems = [MenuItem]()
    var users = Users()
    var favouriteButtonActive = false
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        configureCollectionView()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureFavouriteButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuItemCell
        cell.menuItemTitle = menuItems[indexPath.row].name
        cell.menuItemDescription = menuItems[indexPath.row].description
        cell.menuItemImage.loadImageUsingCacheWithUrlString(urlString: menuItems[indexPath.row].imageUrl)
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editMenuItem", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIBarButtonItem) {
        if favouriteButtonActive {
            unfavouriteRestaurant()
            favoriteButton.image = UIImage(systemName: "heart")
        } else {
            favouriteRestaurant()
            favoriteButton.image = UIImage(systemName: "heart.fill")
        }
        favouriteButtonActive = !favouriteButtonActive
    }
    
    @IBAction func navigationButtonPressed(_ sender: UIButton) {
        if (sender.tag == 0) {
            self.menuItems = self.restaurant.menu!.menuItems
            collectionView.reloadData()
        } else if (sender.tag == 1) {
            self.menuItems = self.restaurant.menu!.menuItems.filter({ (menuItem) -> Bool in
                return menuItem.type == .Entree
            })
        } else if (sender.tag == 2) {
            self.menuItems = self.restaurant.menu!.menuItems.filter({ (menuItem) -> Bool in
                return menuItem.type == .Other
            })
        }
        collectionView.reloadData()
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

extension AdminMenuViewController {
    func configureCollectionView() {
        configureNavigationBar()
        configureNavigationButtons()
        fetchMenuItems()
        collectionView.reloadData()
    }
    
    func configureFavouriteButton() {
        if (self.currentUser.favouriteRestaurants.contains(restaurant.uid)) {
            self.favouriteButtonActive = true
            self.favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            self.favouriteButtonActive = false
            self.favoriteButton.image = UIImage(systemName: "heart")
        }
    }
    
    func configureNavigationButtons() {
        for button in navigationButtons {
            button.layer.cornerRadius = 10.0
        }
    }
    
    func configureNavigationBar() {
        navigationItem.title = restaurant.name
        collectionView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 18)!]
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMenuItem" {
            if let nextViewController = segue.destination as? EditMenuItemViewController {
                let indexPath = sender as! IndexPath
                nextViewController.menuItem = self.menuItems[indexPath.row]
            }
        }
    }
}
