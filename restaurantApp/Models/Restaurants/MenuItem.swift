//
//  MenuItem.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/1/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase

class MenuItem {
    var name: String
    var description: String
    var type: MenuItemType
    var imageUrl: String
    
    init(name: String, description: String, type: MenuItemType, imageUrl: String) {
        self.name = name
        self.type = type
        self.imageUrl = imageUrl
        self.description = description
    }
}


struct Menu {
    var restaurantName: String
    var menuItems: [MenuItem]
    
    init(restaurantName: String, menuItems: [MenuItem]) {
        self.restaurantName = restaurantName
        self.menuItems = menuItems
    }
}
