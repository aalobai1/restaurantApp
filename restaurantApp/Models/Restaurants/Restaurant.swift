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
    
    func deleteImage(completion: @escaping (_ error: Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: logoImageUrl)

        //Removes image from storage
        storageRef.delete { error in
            if let error = error {
                if error.localizedDescription.contains("does not exist") {
                    completion(nil)
                    return
                }
                completion(error)
            } else {
                completion(nil)
                self.logoImageUrl = ""
            }
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (_ error: Error?) -> Void) {
        let storageRef = Storage.storage().reference().child("restaurant_logos/\(name.camelCaseToSnakeCase())/\(name)-\(UUID().uuidString).jpg")
           if let uploadData = image.jpegData(compressionQuality: 0.25) {
               storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                   if error != nil {
                       completion(error)
                   } else {
                    self.logoImageUrl = imageLocationUrlBase + metadata!.path!
                    completion(nil)
                   }
               }
           }
    }
    
    func updateValues(name: String?, location: String?) {
        if (name != nil) {
            self.name = name!
        }
        
        if (location != nil) {
            self.location = location!
        }
    }
    
    func update() {
        let db = Firestore.firestore()
        let collection = db.collection("restaurants")
        
        collection.document(self.uid).updateData([
            "name" : self.name,
            "location" : self.location,
            "logoImageUrl" : self.logoImageUrl
        ])
    }
    
    func createRestaurant() {
        let db = Firestore.firestore()
        let collection = db.collection("restaurants")
        
        collection.addDocument(data: [
            "name" : self.name,
            "location" : self.location,
            "logoImageUrl" : self.logoImageUrl,
            "menuId" : self.menuId
        ])
    }
    
    func fetchMenu(completion: @escaping (_ error: Error?) -> Void) {
        let db = Firestore.firestore()
        let document = db.collection("menu").document(self.menuId)
    
        document.getDocument { (document, err) in
            if err != nil {
                completion(err)
            } else {
                let restaurantName = document!.get("restaurantName") as? String
                let uuid = document!.get("uuid") as! String
                let menuItems: [MenuItem] = []
            
                self.menu = Menu(restaurantName: restaurantName!, menuItems: menuItems, uuid: uuid)
                completion(nil)
            }
        }
    }
}

