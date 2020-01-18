//
//  RestaurantBuilder.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/11/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase

var theRootMenuItems = [
    [
        "name" : "Impossible Burger",
        "description" : "Example description, please add something soon",
        "type" : "Entree",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/Impossible Burger.jpgr"
    ],
    [
        "name" : "BBQ Bacon Cheddar Burger",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/bbq_bacon_cheddar_burger.jpg"
    ],
    [
        "name" : "Cobb Salad",
        "description" : "Example description, please add something soon",
        "type" : "Appetizer",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/cobb_salad.jpg"
    ],
    [
        "name" : "Fall Salad",
        "description" : "Example description, please add something soon",
        "type" : "Entree",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/fall_salad.jpg"
    ],
    [
        "name" : "Fried Catfish",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/fried_catfish.jpg"
    ],
    [
        "name" : "Grilled Salmon",
        "description" : "Example description, please add something soon",
        "type" : "Appetizer",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/grilled_salmon.jpg"
    ],
    [
        "name" : "Island Chicken Ceasar Wrap",
        "description" : "Example description, please add something soon",
        "type" : "Entree",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/island_chicken_caesar_wrap.png"
    ],
    [
        "name" : "Mozz Burger",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/mozz_burger.jpg"
    ],
    [
        "name" : "Reuban Burger",
        "description" : "Example description, please add something soon",
        "type" : "Appetizer",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/reuban_burger.jpg"
    ],
    [
        "name" : "Shrimp and Scallop Burger",
        "description" : "Example description, please add something soon",
        "type" : "Entree",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/shrimp_and_scallop_burger.jpg"
    ],
    [
        "name" : "Shrimp Grits",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/shrimp_grits.jpg"
    ],
    [
        "name" : "Summer Salad",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/summer_salad.jpg"
    ],
    [
        "name" : "The Root Burger",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/the_root_burger.jpg"
    ],
    [
        "name" : "Trackside Garden Salad",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/trackside_garden_salad.jpg"
    ],
    [
        "name" : "Truffle Fries",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/truffle_fries.png"
    ],
    [
        "name" : "Winter Salad",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/winter_salad.jpg"
    ]
]

var sanMarcosItems = [
    [
        "name" : "Burrito Mexicano",
        "description" : "Example description, please add something soon",
        "type" : "Entree",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Burrito Mexicano.jpgr"
    ],
    [
        "name" : "Carne En Su Jugo",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Carne En Su Jugo.jpg"
    ],
    [
        "name" : "Chicken Tortilla Soup",
        "description" : "Example description, please add something soon",
        "type" : "Appetizer",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Chicken Tortilla Soup.jpg"
    ],
    [
        "name" : "Cocktel De Camarón",
        "description" : "Example description, please add something soon",
        "type" : "Entree",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Cocktel De Camarón.jpg"
    ],
    [
        "name" : "Elotes Placero",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Elotes Placero.jpg"
    ],
    [
        "name" : "Enchiladas",
        "description" : "Example description, please add something soon",
        "type" : "Appetizer",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Enchiladas.jpg"
    ],
    [
        "name" : "Nachose Sante Fe",
        "description" : "Example description, please add something soon",
        "type" : "Entree",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Nachose Sante Fe.png"
    ],
    [
        "name" : "Piña Hawaiiana",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Piña Hawaiiana.jpg"
    ],
    [
        "name" : "Steak Cancun",
        "description" : "Example description, please add something soon",
        "type" : "Appetizer",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Steak Cancun.jpg"
    ],
    [
        "name" : "Tacos A La Carte",
        "description" : "Example description, please add something soon",
        "type" : "Entree",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Tacos A La Carte.jpg"
    ],
    [
        "name" : "Tacos de Pollo Asado",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Tacos de Pollo Asado.jpg"
    ],
    [
        "name" : "Texas Fajita Quesidilla",
        "description" : "Example description, please add something soon",
        "type" : "Other",
        "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/san_marcos/Texas Fajita Quesidilla.jpg"
    ]
]

class DemoData {
    func createMenu() {
        let db = Firestore.firestore()
        let collection = db.collection("menu_items")
        
        sanMarcosItems.forEach { (menuItem) in
            let ref = collection.document()
            var data = menuItem
            data["uuid"] = ref.documentID
            data["menuId"] = "RXv8wPPKwTxYfUdoAZ5Y"
            ref.setData(data)
        }
        
        theRootMenuItems.forEach { (menuItem) in
            let ref = collection.document()
            var data = menuItem
            data["uuid"] = ref.documentID
            data["menuId"] = "oRwfdcFMiUWkGlsDPPoc"
            ref.setData(data)
        }
    }
}
