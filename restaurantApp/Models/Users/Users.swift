//
//  Users.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/24/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase

class Users {
    
    var allUsers: [User] = []
    
    func fetchUser(withId uid: String, completion: @escaping (_ user: User?,_ error: Error?) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("users")
        collection.whereField("uuid", isEqualTo: uid).getDocuments { (snapshot, err) in
            if err != nil {
                completion(nil, err)
            } else {
                for document in snapshot!.documents {
                   let email = document.get("email") as! String
                   let type = document.get("type") as! String
                   let uuid = document.get("uuid") as! String
                   let favouriteRestaurants = document.get("favouriteRestaurants") as? [String]
                    
                    var adminRestaurants: [String]?
                    
                    if type == "admin" {
                       adminRestaurants = document.get("adminRestaurants") as? [String]
                    }
                    
                   completion(User(email: email, uuid: uuid, type: type, favouriteRestaurants: favouriteRestaurants, adminRestaurants: adminRestaurants), nil)
                }
            }
        }
    }
    
    func requestUsers(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("users")
        collection.getDocuments { (snapshot, err) in
            if err != nil {
                
            } else {
                for document in snapshot!.documents {
                    let email = document.get("email") as! String
                    let type = document.get("type") as! String
                    let uuid = document.get("uuid") as! String
                    let favouriteRestaurants = document.get("favouriteRestaurants") as? [String]
                    let user = User(email: email, uuid: uuid, type: type, favouriteRestaurants: favouriteRestaurants, adminRestaurants: nil)
                    self.allUsers.append(user)
                }
                completion()
            }
        }
    }
    
}

