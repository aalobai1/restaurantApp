//
//  File.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/24/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import Foundation
import Firebase

enum UserType: String {
    case admin = "admin"
    case client = "client"
}

class User {
    var email: String
    var password: String
    var uuid: String!
    var type: UserType! = .client
    var favouriteRestaurants: [String] = []
    var adminRestaurants: [String] = []
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    convenience init(email: String, uuid: String, type: String, favouriteRestaurants: [String]?, adminRestaurants: [String]?) {
        self.init(email: email, password: "")
        self.uuid = uuid
        self.type = UserType(rawValue: type)
        
        if favouriteRestaurants != nil {
            self.favouriteRestaurants = favouriteRestaurants!
        }
        
        if adminRestaurants != nil {
            self.adminRestaurants = adminRestaurants!
        }
        
    }
    
    func signUp(completion: @escaping (_ error: Error?,_ result: AuthDataResult?,_ user: User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authUser, err) in
            if err != nil {
                completion(err, nil, nil)
            } else {
                self.sendVerificationEmail { (err) in
                    if err != nil {
                        completion(err, nil, nil)
                    } else {
                        self.uuid = authUser!.user.uid
                        self.createUser(ofType: .client)
                        completion(nil, authUser, self)
                    }
                }
            }
        }
    }
    
    func login(completion: @escaping (_ error: Error?,_ result: AuthDataResult?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authUser, err) in
            if err != nil {
                completion(err, nil)
            } else {
                completion(nil, authUser)
            }
        }
    }
    
    func logout(completion: @escaping (_ error: Error?, _ loggedOut: Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "USER_KEY_UID")
            UserDefaults.standard.synchronize()
            completion(nil, true)
        } catch let err {
            completion(err, false)
        }
    }
    
    func createUser(ofType type: UserType) {
        let db = Firestore.firestore()
        let collection = db.collection("users")
        
        let userData = [
            "email": self.email,
            "type": type.rawValue,
            "uuid": self.uuid!
        ]
        
        collection.addDocument(data: userData) { (err) in
            if err != nil {
                print("error")
            }
        }
    }
    
    func favouriteRestaurant(restaurant: Restaurant, completion: @escaping (_ error: Error?) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("users")
    
        collection.whereField("uuid", isEqualTo: self.uuid!).getDocuments { (snapshot, err) in
            if err != nil {
               completion(err)
               print("we didnt get it fam")
            } else {
                for document in snapshot!.documents {
                    collection.document(document.documentID).updateData([
                        "favouriteRestaurants" : FieldValue.arrayUnion([restaurant.uid])
                    ]) { (err) in
                        if err != nil {
                            completion(err)
                        } else {
                            self.favouriteRestaurants.append(restaurant.uid)
                            completion(nil)
                        }
                    }
                    
                }
            }
        }
    }
    
    func unfavouriteRestaurant(restaurant: Restaurant, completion: @escaping (_ error: Error?) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("users")
    
        collection.whereField("uuid", isEqualTo: self.uuid!).getDocuments { (snapshot, err) in
            if err != nil {
               completion(err)
               print("we didnt get it fam")
            } else {
                for document in snapshot!.documents {
                    collection.document(document.documentID).updateData([
                        "favouriteRestaurants" : FieldValue.arrayRemove([restaurant.uid])
                    ]) { (err) in
                        if err != nil {
                            completion(err)
                        } else {
                            if let index = self.favouriteRestaurants.firstIndex(of: restaurant.uid) {
                                self.favouriteRestaurants.remove(at: index)
                            }
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func sendVerificationEmail(completion: @escaping (_ sendEmailError: Error?) -> Void) {
        let authUser = Auth.auth().currentUser
        if authUser != nil && !authUser!.isEmailVerified {
            authUser?.sendEmailVerification(completion: { (err) in
                if err != nil {
                    completion(err)
                } else {
                    completion(nil)
                }
            })
        } else {
            print("something went wrong")
        }
    }
}

