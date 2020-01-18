//
//  MenuViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/30/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit

class AdminMenuViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var navigationButtons: [UIButton]!
    @IBOutlet weak var navigationButtonsContainer: UIView!
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var editRestaurantButton: UIBarButtonItem!
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    
    var resultSearchController = UISearchController()
    
    var filteredMenuItems = [MenuItem]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationButtonsContainer.layer.borderWidth = 0.0
        navigationController?.navigationBar.shadowImage = UIImage()
        collectionView.layer.borderWidth = 0.0
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.contentInset = UIEdgeInsets.zero
        configureCollectionView()
        setupSearch()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = restaurant.name
        fetchMenuItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultSearchController.dismiss(animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filteredMenuItems.count
        } else {
            return menuItems.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editMenuItem", sender: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if resultSearchController.isActive {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuItemCell
            cell.menuItemTitle = filteredMenuItems[indexPath.row].name
            cell.menuItemDescription = filteredMenuItems[indexPath.row].description
            cell.menuItemImage.loadImageUsingCacheWithUrlString(urlString: filteredMenuItems[indexPath.row].imageUrl)
            cell.layoutSubviews()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuItemCell
            cell.menuItemTitle = menuItems[indexPath.row].name
            cell.menuItemDescription = menuItems[indexPath.row].description
            cell.menuItemImage.loadImageUsingCacheWithUrlString(urlString: menuItems[indexPath.row].imageUrl)
            cell.layoutSubviews()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
        } else if (sender.tag == 3) {
            self.menuItems = self.restaurant.menu!.menuItems.filter({ (menuItem) -> Bool in
                return menuItem.type == .Appetizer
            })
        }
        collectionView.reloadData()
    }
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToAddMenuItem", sender: nil)
    }
    
    @IBAction func editRestaurantButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToEditRestaurantView", sender: nil)
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
    
    func configureNavigationButtons() {
        for button in navigationButtons {
            button.layer.cornerRadius = 10.0
        }
    }
    
    func configureNavigationBar() {
        collectionView.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 18)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    
    func fetchMenuItems() {
        restaurant.fetchMenu { (err) in
            if err != nil {
                self.alert(message: err!.localizedDescription)
            } else {
                self.restaurant.menu?.fetchMenuItems(completion: { (err) in
                    if err != nil {
                        self.alert(message: err!.localizedDescription)
                    } else {
                        self.menuItems = self.restaurant.menu!.menuItems
                        self.collectionView.reloadData()
                    }
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMenuItem" {
            if let nextViewController = segue.destination as? EditMenuItemViewController {
                let indexPath = sender as! IndexPath
                nextViewController.menuItem = self.menuItems[indexPath.row]
                nextViewController.editAction = .EDIT
            }
        }
        
        if segue.identifier == "goToAddMenuItem" {
            if let nextViewController = segue.destination as? EditMenuItemViewController {
                nextViewController.editAction = .CREATE
                nextViewController.restaurant = self.restaurant
            }
        }
        
        if segue.identifier == "goToEditRestaurantView" {
            if let nextViewController = segue.destination as? EditRestaurantViewController {
                nextViewController.restaurant = self.restaurant
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        resultSearchController.searchBar.resignFirstResponder()
    }
    
    func setupSearch() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.searchBarStyle = .default
                
            controller.searchBar.setTextField(color: UIColor.white)
            controller.searchBar.set(textColor: UIColor.black)
            controller.searchBar.setSearchImage(color: UIColor.black)
                
            controller.hidesNavigationBarDuringPresentation = false
            controller.obscuresBackgroundDuringPresentation = false
            
            controller.searchBar.placeholder = "Find a dish!"
            controller.searchBar.isTranslucent = false
                
            controller.searchBar.backgroundImage = UIImage()
                
            searchBarView.addSubview(controller.searchBar)
            controller.searchBar.pinEdges(to: searchBarView)
            controller.searchBar.heightAnchor.constraint(equalToConstant: searchBarView.bounds.size.height).isActive = true
                
            return controller
        })()
    }
    func updateSearchResults(for searchController: UISearchController) {
        filteredMenuItems.removeAll(keepingCapacity: false)
        
        let filteredItems = menuItems.filter { (menuItem) -> Bool in
            let name = menuItem.name.lowercased()
            return(name.contains(searchController.searchBar.text!.lowercased()))
        }
        filteredMenuItems = filteredItems
        self.collectionView.reloadData()
    }
}
