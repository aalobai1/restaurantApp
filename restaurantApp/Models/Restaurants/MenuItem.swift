//
//  MenuItem.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/1/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase

let imageLocationUrlBase = "gs://restaurantapp-33d03.appspot.com/"

enum MenuItemType: String {
    case Entree = "Entree"
    case Appetizer = "Appetizer"
    case Other = "Other"
}

class MenuItem {
    var name: String
    var description: String
    var type: MenuItemType
    var imageUrl: String
    var uuid: String
    var restaurantName: String
    var menuId: String
    
    init(name: String, description: String, type: MenuItemType, imageUrl: String, uuid: String, restaurantName: String, menuId: String) {
        self.name = name
        self.type = type
        self.imageUrl = imageUrl
        self.description = description
        self.uuid = uuid
        self.restaurantName = restaurantName
        self.menuId = menuId
    }
    
    convenience init(name: String, description: String, type: MenuItemType, imageUrl: String, restaurantName: String, menuId: String) {
        self.init(name: name, description: description, type: type, imageUrl: imageUrl, uuid: "", restaurantName: restaurantName, menuId: menuId)
    }
    
    func destory() {
        let db = Firestore.firestore()
        let collection = db.collection("menu_items")
        let ref = collection.document(self.uuid)
        
        ref.delete { (err) in
            if err != nil {
                
            } else {
                
            }
        }
    }
    
    func create() {
        let db = Firestore.firestore()
        let collection = db.collection("menu_items")
        let ref = collection.document()
        
        ref.setData([
            "name" : name,
            "description" : description,
            "imageUrl" : imageUrl,
            "uuid" : ref.documentID,
            "restaurantName" : restaurantName,
            "menuId" : menuId,
            "type" : type.rawValue
        ])
    }
    
    func updateValues(name: String?, description: String?, type: MenuItemType?, imageUrl: String?) {
        if (name != nil) {
            self.name = name!
        }
        
        if (description != nil) {
            self.description = description!
        }
        
        if (type != nil) {
            self.type = type!
        }
        
        if imageUrl != nil {
            self.imageUrl = imageUrl!
        }
    }
    
    
    public func updateImage(image: UIImage, completion: @escaping (_ error: Error?,_ newImageUrl: String) -> Void) {
        self.deleteImage { (err) in
            if err != nil {
                completion(err, "")
            } else {
                self.uploadImage(image: image) { (err, newImageUrl) in
                    if err != nil {
                        completion(err, "")
                    } else {
                        completion(nil, newImageUrl)
                    }
                }
            }
        }
    }
    
    
    private func deleteImage(completion: @escaping (_ error: Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: imageUrl)

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
                self.imageUrl = ""
            }
        }
    }
    
    public func uploadImage(image: UIImage, completion: @escaping (_ error: Error?,_ newImageUrl: String) -> Void) {
        let storageRef = Storage.storage().reference().child("menu_items/\(restaurantName.camelCaseToSnakeCase())/\(name)-\(UUID().uuidString).jpg")
           if let uploadData = image.jpegData(compressionQuality: 0.25) {
               storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                   if error != nil {
                       completion(error, "")
                   } else {
                    completion(nil, imageLocationUrlBase + metadata!.path!)
                   }
               }
           }
    }
    
    func save() {
        let db = Firestore.firestore()
        let collection = db.collection("menu_items")
        
        collection.document(self.uuid).updateData([
            "name" : self.name,
            "type" : self.type.rawValue,
            "imageUrl" : self.imageUrl,
            "description" : self.description
        ])
    }
}


class Menu {
    var restaurantName: String
    var uuid: String
    var menuItems: [MenuItem]
    
    init(restaurantName: String, menuItems: [MenuItem], uuid: String) {
        self.restaurantName = restaurantName
        self.menuItems = menuItems
        self.uuid = uuid
    }
    
    func fetchMenuItems(completion: @escaping (_ error: Error?) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("menu_items")
        
        collection.whereField("menuId", isEqualTo: self.uuid).getDocuments { (snapshot, err) in
            if err != nil {
               completion(err)
            } else {
                for document in snapshot!.documents {
                    let name = document.get("name") as! String
                    let description = document.get("description") as! String
                    let type = MenuItemType(rawValue: document.get("type")! as! String)!
                    let imageUrl = document.get("imageUrl") as! String
                    let uuid = document.get("uuid") as! String
                    let menuId = document.get("menuId") as! String
                    
                    self.menuItems.append(MenuItem(name: name, description: description, type: type, imageUrl: imageUrl, uuid: uuid, restaurantName: self.restaurantName, menuId: menuId))
                }
                completion(nil)
            }
        }
    }
    
    func saveMenu() {
        let db = Firestore.firestore()
        let collection = db.collection("menu")

        collection.addDocument(data: [
            "menuItems" : self.menuItems.map({ (menuItem) in
                return ([
                    "description" : menuItem.description,
                    "imageUrl" : "gs://restaurantapp-33d03.appspot.com/menu_items/the_root/\(menuItem.imageUrl).jpg",
                    "name" : menuItem.name,
                    "type" : menuItem.type.rawValue
                ])
            }),
            "restaurantName" : self.restaurantName
        ])
    }
    
    func addMenuItem(menuItem: MenuItem) {
        self.menuItems.append(menuItem)
    }
}
