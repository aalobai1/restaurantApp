//
//  UIImageViewExtensions.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/25/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage


let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: urlString)
        
        storageRef.getData(maxSize:  1 * 1024 * 1024) { (data, err) in
            if err != nil {
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                    }
                    
                    self.image = UIImage(data: data!)
                }
            }
        }
    }
}
