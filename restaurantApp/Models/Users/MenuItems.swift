//
//  MenuItems.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/1/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase

class MenuItems {
    func addMenuItems() {
        let db = Firestore.firestore()
        let collection = db.collection("menu")
        collection.document("Mz6jhdawbY0Pm6igGPBc").updateData(["menuItems" : FieldValue.arrayUnion(
                [
                    [
                    "description" : "Example description of said item",
                    "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/bbq_bacon_cheddar_burger.jpg",
                    "name" : "BBQ Bacon Cheddar",
                    "type" : "Entree"
                    ],
                    [
                    "description" : "Example description of said item",
                    "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/cobb_salad.jpg",
                    "name" : "Cobb Salad",
                    "type" : "Entree"
                    ],
                    [
                       "description" : "Example description of said item",
                       "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/fall_salad.jpg",
                       "name" : "Fall Salad",
                       "type" : "Entree"
                    ],
                    [
                       "description" : "Example description of said item",
                       "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/fried_catfish.jpg",
                       "name" : "Fried Catfish",
                       "type" : "Entree"
                    ],
                    [
                       "description" : "Example description of said item",
                       "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/grilled_salmon.jpg",
                       "name" : "Grilled Salmon",
                       "type" : "Entree"
                    ],
                    [
                         "description" : "Example description of said item",
                         "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/island_chicken_caesar_wrap.png",
                         "name" : "Island Chicken Caesar Wrap",
                         "type" : "Entree"
                    ],
                    [
                         "description" : "Example description of said item",
                         "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/mozz_burger.jpg",
                         "name" : "Mozz Burger",
                         "type" : "Entree"
                    ],
                    [
                         "description" : "Example description of said item",
                         "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/reuban_burger.jpg",
                         "name" : "Reuban Burger",
                         "type" : "Entree"
                    ],
                    [
                         "description" : "Example description of said item",
                         "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/shrimp_and_scallop_burger.jpg",
                         "name" : "Shrimp and Scallop Burger",
                         "type" : "Entree"
                    ],
                    [
                         "description" : "Example description of said item",
                         "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/shrimp_grits.jpg",
                         "name" : "Shrimp Grits",
                         "type" : "Entree"
                    ],
                    [
                         "description" : "Example description of said item",
                         "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/summer_salad.jpg",
                         "name" : "Summer Salad",
                         "type" : "Entree"
                    ],
                    [
                         "description" : "Example description of said item",
                         "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/the_root_burger.jpg",
                         "name" : "The Root Burger",
                         "type" : "Entree"
                    ],
                    [
                         "description" : "Example description of said item",
                         "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/trackside_garden_salad.jpg",
                         "name" : "Trackside Garden Salad",
                         "type" : "Entree"
                    ]
                ]
            )
          ]
        )
    }
}
