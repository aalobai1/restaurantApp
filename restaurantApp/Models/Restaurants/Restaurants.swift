//
//  Restaurants.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/25/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase

class Restaurants {
    var availableRestaurants: [Restaurant] = []
    var favouriteRestaurants: [Restaurant] = []
    
    func fetchRestaurants(completion: @escaping (_ error: Error?) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("restaurants")
        
        collection.getDocuments { (snapshot, err) in
            if err != nil {
                completion(err)
            } else {
                for document in snapshot!.documents {
                    let name = document.get("name") as! String
                    let location = document.get("location") as! String
                    let logoImageUrl = document.get("logoImageUrl") as! String
                    let menuId = document.get("menuId") as! String
                    let restaurant = Restaurant(name: name, location: location, logoImageUrl: logoImageUrl, menuId: menuId, uid: document.documentID)
                    self.availableRestaurants.append(restaurant)
                }
                completion(nil)
            }
        }
    }
    
    func fetchFavouriteRestaurants(favouriteRestaurants: [String], completion: @escaping (_ error: Error?, _ restaurants: [Restaurant]?) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("restaurants")
        
        var restaurants: [Restaurant] = []
        
        for restaurantId in favouriteRestaurants {
            collection.document(restaurantId).getDocument { (document, err) in
                if err != nil {
                    
                } else {
                    let name = document!.get("name") as! String
                    let location = document!.get("location") as! String
                    let logoImageUrl = document!.get("logoImageUrl") as! String
                    let menuId = document!.get("menuId") as! String
                    let restaurant = Restaurant(name: name, location: location, logoImageUrl: logoImageUrl, menuId: menuId, uid: document!.documentID)
                   restaurants.append(restaurant)
                }
            }
        }
    }
}
