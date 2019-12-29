//
//  ClientTabBarController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/24/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit

class ClientTabBarController: UITabBarController {
    var currentUser: User!
    var usersStore: Users!
    var restaurants: Restaurants!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
