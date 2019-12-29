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
    var favoriteButton: UIButton!
    
    var titleView : UILabel = {
        var textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Noto Sans Kannada", size: 20)
        return textView
    }()
    
    var infoView : UILabel = {
        var textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var mainStackView : UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    var textStackView : UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(mainStackView)
        
        configureMainStack()
        configureMainImage()
        configureMessageView()
       
        
        self.backgroundColor = UIColor.gray
        
        self.layoutMargins = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
    }
    
    func configureMainStack() {
        mainStackView.addArrangedSubview(textStackView)
        mainStackView.addArrangedSubview(mainImageView)
    }
    
    func configureMainImage() {
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        mainImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func configureMessageView() {
        textStackView.addArrangedSubview(titleView)
        textStackView.addArrangedSubview(infoView)
        textStackView.distribution = .fillProportionally
        
        textStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        textStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        textStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let message = message {
            titleView.text = message.title
        }
        
        if let info = message?.info {
            infoView.text = info
        }
        
        if let image = mainImage {
            mainImageView.image = image
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

