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
    
    var titleView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Noto Sans Kannada", size: 30)
        return textView
    }()
    
    var infoView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var mainImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        favoriteButton = UIButton()
        
        self.addSubview(mainImageView)
        self.addSubview(stackView)
        self.addSubview(favoriteButton)
        
        configureMainImage()
        configureMessageView()
        configureFavoriteButton()
        
        self.layoutMargins = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
    }
    
    func configureMainImage() {
        mainImageView.leftAnchor.constraint(equalTo: self.mainImageView.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        mainImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func configureMessageView() {
        stackView.axis = .vertical
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(infoView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func configureFavoriteButton() {

        favoriteButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        favoriteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
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

