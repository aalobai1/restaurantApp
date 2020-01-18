//
//  EditMenuItemViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/1/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import UIKit

enum EditViewAction {
    case EDIT
    case CREATE
}

let buttonTagMap: [MenuItemType : Int] = [
    MenuItemType.Entree : 1,
    MenuItemType.Appetizer : 2,
    MenuItemType.Other : 3
]

class EditMenuItemViewController: UIViewController {
    var editAction: EditViewAction!
    var menuItem: MenuItem!
    var itemCategory: MenuItemType!
    
    var restaurant: Restaurant!
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    @IBOutlet var itemCategoryButtons: [UIButton]!
    @IBOutlet weak var itemPhotoImageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var editBUtton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var itemActionLabel: UILabel!
    
    var itemIsEditing: Bool = false {
        didSet {
            if itemIsEditing == true {
                self.editBUtton.isEnabled = false
                self.saveButton.isEnabled = true
            } else if itemIsEditing == false {
                self.editBUtton.isEnabled = true
                self.saveButton.isEnabled = false
            }
        }
    }
    
    var newItemName: String!
    var newItemDescription: String!
    var selectedItemType: MenuItemType!
    var newItemPhoto: UIImage!
    var newImageUrl: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefillValues()
        configureUI()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        allowEditing(true)
    }
    
    
    @IBAction func saveButtonPresssed(_ sender: UIBarButtonItem) {
        allowEditing(false)
        self.getNewItemValues()
    }
    
    @IBAction func editImageButtonPressed(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { (image) in
            self.newItemPhoto = image
            self.itemPhotoImageView.image = image
        }
    }
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        self.selectedItemType = buttonTagMap.key(forValue: sender.tag)
        configureItemCategoryButtons()
    }
}

extension EditMenuItemViewController {
    func getNewItemValues() {
        if editAction == .CREATE {
            self.menuItem = MenuItem(name: "", description: "", type: .Entree, imageUrl: "", restaurantName: restaurant.name, menuId: restaurant.menuId)
        }
        self.getItemTextAttributes()
        self.getItemCategory()
        self.getItemImage()
    }
    
    func saveNewItemAttributes() {
        if editAction == .CREATE {
            self.menuItem = MenuItem(name: self.newItemName, description: self.newItemDescription, type: self.selectedItemType, imageUrl: self.newImageUrl, restaurantName: restaurant.name, menuId: restaurant.menuId)
            self.menuItem.create()
        } else if editAction == .EDIT {
            self.menuItem.updateValues(name: self.newItemName, description: self.newItemDescription, type: self.selectedItemType, imageUrl: newImageUrl)
            self.menuItem.save()
        }
    }
    
    func getItemTextAttributes() {
        if let newItemName = self.itemNameTextField.text,
            let newItemDescription = self.itemDescriptionTextField.text {
            self.newItemName = newItemName
            self.newItemDescription = newItemDescription
        } else {
            self.alert(message: "Please input values for all fields")
        }
    }
    
    func getItemCategory() {
        if selectedItemType != nil {
            return
        } else {
            self.selectedItemType = self.menuItem.type
        }
    }
    
    func getItemImage() {
        startLoading()
        
        
        
        if editAction == .CREATE {
            if (newItemPhoto == nil || newItemName == nil || newItemDescription == nil || selectedItemType == nil) {
                self.dismiss(animated: true) {
                    self.alert(message: "Please fill out all values in order to continue")
                }
            } else {
                self.menuItem.uploadImage(image: newItemPhoto) { (err, newImageUrl) in
                    if err != nil {
                        self.alert(message: err!.localizedDescription)
                    } else {
                        self.dismiss(animated: true) {
                            self.newImageUrl = newImageUrl
                            self.saveNewItemAttributes()
                        }
                    }
                }
            }
        } else if editAction == .EDIT {
            if newItemPhoto != nil {
                self.menuItem.updateImage(image: newItemPhoto) { (err, newImageUrl) in
                    if err != nil {
                        self.alert(message: err!.localizedDescription)
                    } else {
                        self.dismiss(animated: true) {
                            self.newImageUrl = newImageUrl
                            self.saveNewItemAttributes()
                        }
                    }
                }
            } else {
                dismiss(animated: true, completion: nil)
                self.saveNewItemAttributes()
            }
        }
    }
    
    func allowEditing(_ bool: Bool) {
        self.itemIsEditing = bool
        self.itemNameTextField.isEnabled = bool
        self.itemDescriptionTextField.isEnabled = bool
        self.editImageButton.isEnabled = bool
        self.itemCategoryButtons.forEach { (button) in
            button.isEnabled = bool
        }
    }
    
    func configureUI() {
        if editAction == .CREATE {
            self.itemActionLabel.text = "Add a new Item!"
            allowEditing(true)
        } else if editAction == .EDIT {
            self.itemActionLabel.text = "Edit Item!"
            allowEditing(false)
        }
        
        
        self.itemCategoryButtons.forEach { (button) in
            button.layer.cornerRadius = 10
        }
    }
    
    func prefillValues() {
        if editAction == .EDIT {
            itemNameTextField.text! = self.menuItem.name
            itemDescriptionTextField.text! = self.menuItem.description
            selectedItemType = self.menuItem.type
            itemPhotoImageView.loadImageUsingCacheWithUrlString(urlString: self.menuItem.imageUrl)
            configureItemCategoryButtons()
        }
    }
    
    func configureItemCategoryButtons() {
        let selectedButton = itemCategoryButtons.filter { (button) -> Bool in
            return button.tag == buttonTagMap[selectedItemType]
        }
        
        itemCategoryButtons.forEach { (button) in
            if button.tag != buttonTagMap[selectedItemType] {
                button.backgroundColor = UIColor(hexString: orangeAccent)
            }
        }
        
        
        selectedButton.first!.backgroundColor = UIColor(hexString: blueAccent)
    }
}
