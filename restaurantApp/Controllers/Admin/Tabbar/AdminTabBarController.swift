//
//  AdminTabBarController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/1/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import UIKit

class AdminTabBarController: UITabBarController {
    var currentUser: User!
    var usersStore: Users!
    var restaurants: Restaurants!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentUser.adminRestaurants)
        setupTabBar()
        // Do any additional setup after loading the view.
    }
    
    func setupTabBar() {
        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = UIColor(hexString: orangeAccent)
        tabBar.shadowImage = UIImage()
        tabBar.unselectedItemTintColor = UIColor(hexString: blueAccent)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
