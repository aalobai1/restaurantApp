//
//  MenuItemCell.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/26/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import Foundation
import UIKit

class MenuItemCell: UICollectionViewCell {
    var menuItemTitle: String?
    var menuItemDescription: String?
    
    @IBOutlet weak var menuItemImage: UIImageView!
    @IBOutlet weak var menuItemName: UILabel!
    @IBOutlet weak var menuItemDescriptionLbl: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let title = menuItemTitle {
            menuItemName.text = title
        }
        
        if let description = menuItemDescription {
            menuItemDescriptionLbl.text = description
        }
        
        configureContentView()
        configureImageView()
    }
    
    func configureContentView() {
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.borderWidth = 0.5
    }
    
    func configureImageView() {
        self.menuItemImage.layer.cornerRadius = 10
    }
}
