 //
//  CustomCell.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/24/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import Foundation
import UIKit

class RestaurantCell: UITableViewCell {
    var message : RestaurantInfo?
    var mainImage : UIImage?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
        
        if let title = message?.title {
            titleLabel.text = title
        }
        
        if let info = message?.info {
            infoLabel.text = info
        }
    }
    
    func configureView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
    
        mainView.layer.cornerRadius = 20.0
        mainView.layer.borderColor = UIColor.clear.cgColor
        mainView.layer.masksToBounds = false
        
        mainView.layer.backgroundColor = UIColor(hexString: "#E8E8E8").cgColor
        mainView.layer.applySketchShadow(y: 1)
    }
}

