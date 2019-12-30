//
//  RestaurantCollectionViewCell.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/29/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    var name: String!
    var info: String!
    var imageUrl: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let n = name {
            restaurantName.text = n
        }
        
        if let i = info {
            restaurantInfo.text = i
        }
    }
    
    var restaurantImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var restaurantName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: 25)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var restaurantInfo : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Light", size: 18)
        return label
    }()
    
    func setupViews() {
        addSubview(restaurantImage)
        
        restaurantImage.widthAnchor.constraint(equalToConstant: self.frame.size.width / 3).isActive = true
        addConstraintsWithFormat("V:|[v0]|", views: restaurantImage)
        
        
        let uiView = UIView()
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillProportionally
        stack.addArrangedSubview(restaurantName)
        stack.addArrangedSubview(restaurantInfo)
        
        uiView.addSubview(stack)
        
        addSubview(uiView)
        
        restaurantName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        restaurantInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        restaurantName.widthAnchor.constraint(equalToConstant: (self.frame.size.width * 2) / 3).isActive = true
//        restaurantInfo.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        addConstraintsWithFormat("H:|-8-[v0]-8-[v1]-8-|", views: stack, restaurantImage)
        addConstraintsWithFormat("V:|-20-[v0]-10-|", views: stack)
        
        configureImageViewConstraints()
        setupShadow()
    }
    
    func configureImageViewConstraints() {
//        addConstraintsWithFormat("H:[v0(150)]-8-|", views: restaurantImage)
    }
    
    
    func setupShadow() {
        
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = false
        
        self.contentView.layer.backgroundColor = UIColor(hexString: "#E8E8E8").cgColor
        
        self.contentView.layer.applySketchShadow(color: UIColor.gray, x: 0, y: 0, blur: 0, spread: 0)
    }
}
