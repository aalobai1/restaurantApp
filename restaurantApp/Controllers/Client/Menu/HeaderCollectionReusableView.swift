//
//  HeaderCollectionReusableView.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/30/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet var tabBarButtons: [UIButton]!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for button in tabBarButtons {
            button.layer.cornerRadius = 10.0
        }
    }
}
