//
//  Restaurant.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/25/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

enum MenuItemType: String {
    case Entree = "Entree"
    case Other = "Other"
}

class Restaurant {
    var name: String
    var uid: String
    var location: String
    var logoImageUrl: String
    var menuId: String
    
    var menu: Menu?
    
    init(name: String, location: String, logoImageUrl: String, menuId: String, uid: String) {
        self.name = name
        self.location = location
        self.logoImageUrl = logoImageUrl
        self.menuId = menuId
        self.uid = uid
    }
    
    func fetchMenu(completion: @escaping (_ error: Error?) -> Void) {
        let db = Firestore.firestore()
        let document = db.collection("menu").document(self.menuId)
    
        document.getDocument { (document, err) in
            if err != nil {
                completion(err)
            } else {
                let restaurantName = document!.get("restaurantName") as? String
                let menuItemsArray = document!.get("menuItems") as? [[String: String]]
                var menuItems: [MenuItem] = []
                    
                menuItems = menuItemsArray!.map({ (item) in
                    let name = item["name"]!
                    let description = item["description"]!
                    let type = MenuItemType(rawValue: item["type"]!)!
                    let imageUrl = item["imageUrl"]!
                    return MenuItem(name: name, description: description, type: type, imageUrl: imageUrl)
                })
            
                self.menu = Menu(restaurantName: restaurantName!, menuItems: menuItems)
                completion(nil)
            }
        }
    }
}

