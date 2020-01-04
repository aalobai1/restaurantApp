//
//  EditMenuItemViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/1/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import UIKit

class EditMenuItemViewController: UIViewController {
    var menuItem: MenuItem!
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    @IBOutlet var itemCategoryButtons: [UIButton]!
    @IBOutlet weak var itemPhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefillValues()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditMenuItemViewController {
    func prefillValues() {
        itemNameTextField.text! = self.menuItem.name
        itemDescriptionTextField.text! = self.menuItem.description
        itemPhotoImageView.loadImageUsingCacheWithUrlString(urlString: self.menuItem.imageUrl)
    }
}
