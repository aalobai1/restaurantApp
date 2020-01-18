//
//  EditMenuItemViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/1/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import UIKit

class EditRestaurantViewController: UIViewController {
    var restaurant: Restaurant!
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    
    @IBOutlet weak var itemPhotoImageView: UIImageView!
    
    @IBOutlet weak var editImageButton: UIButton!
    
    @IBOutlet weak var editBUtton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var itemIsEditing = false
    
    var newRestaurantName: String!
    var newRestaurantLocation: String!
    var newRestaurantLogo: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefillValues()
        allowEditing(false)
        self.saveButton.isEnabled = false
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        allowEditing(true)
        sender.isEnabled = false
        self.saveButton.isEnabled = true
    }
    
    
    @IBAction func saveButtonPresssed(_ sender: UIBarButtonItem) {
        allowEditing(false)
        sender.isEnabled = false
        self.editBUtton.isEnabled = true
        
        self.getNewItemValues()
        self.restaurant.updateValues(name: self.newRestaurantName, location: self.newRestaurantLocation)
        
        self.restaurant.update()
    }
    
    @IBAction func editImageButtonPressed(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { (image) in
            self.newRestaurantLogo = image
            self.getItemImage()
        }
    }
}

extension EditRestaurantViewController {
    func getNewItemValues() {
        self.getItemTextAttributes()
    }
    
    func getItemTextAttributes() {
        if let newItemName = self.itemNameTextField.text,
            let newItemDescription = self.itemDescriptionTextField.text {
            self.newRestaurantName = newItemName
            self.newRestaurantLocation = newItemDescription
        } else {
            self.alert(message: "Please input values for all fields")
        }
    }
    
    func getItemImage() {
        startLoading()
        self.restaurant.deleteImage { (err) in
            if err != nil {
                self.alert(message: err!.localizedDescription)
            } else {
                self.restaurant.uploadImage(image: self.newRestaurantLogo) { (err) in
                    if err != nil {
                        self.alert(message: err!.localizedDescription)
                    } else {
                        self.dismiss(animated: true) {
                            self.itemPhotoImageView.image = self.newRestaurantLogo
                        }
                    }
                }
            }
        }
    }
    
    func allowEditing(_ bool: Bool) {
        self.itemIsEditing = bool
        self.itemNameTextField.isEnabled = bool
        self.itemDescriptionTextField.isEnabled = bool
        self.editImageButton.isEnabled = bool
    }
    
    func prefillValues() {
        itemNameTextField.text! = self.restaurant.name
        itemDescriptionTextField.text! = self.restaurant.location
        itemPhotoImageView.loadImageUsingCacheWithUrlString(urlString: self.restaurant.logoImageUrl)
    }
}
