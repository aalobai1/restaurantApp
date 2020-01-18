//
//  ClientTabBarController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/24/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit

var orangeAccent = "#FE9C3C"
var blueAccent = "#82AEC8"

class ClientTabBarController: UITabBarController, UITabBarControllerDelegate {
    var currentUser: User!
    var usersStore: Users!
    var restaurants: Restaurants!
    
    var selected = true
    
    var middleBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupMiddleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 1
        configureMiddleButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag != 1 {
            selected = false
            configureMiddleButton()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let nav = viewController as! UINavigationController
        nav.popToRootViewController(animated: false)
    }
    
    
    func setupMiddleButton() {
        middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 30, y: -27.5, width: 60, height: 60))
        
        //STYLE THE BUTTON YOUR OWN WAY
        middleBtn.layer.cornerRadius = 0.5 * middleBtn.bounds.size.width
        middleBtn.clipsToBounds = true
        
        middleBtn.setImage(UIImage(named: "Fork and knife"), for: .normal)
        middleBtn.contentMode = .center
        middleBtn.imageView!.contentMode = .scaleAspectFit
        middleBtn.imageView?.tintColor = UIColor.white
        middleBtn.backgroundColor = UIColor(hexString: blueAccent)
        
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

        self.view.layoutIfNeeded()
    }

    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 1  //to select the middle tab. use "1" if you have only 3 tabs.
        let nav = self.selectedViewController as! UINavigationController
        nav.popToRootViewController(animated: true)
        
        selected = true
        configureMiddleButton()
        animateMiddleButton(sender: sender)
    }
    
    func animateMiddleButton(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
           UIButton.animate(withDuration: 1.5,
           delay: 0,
           usingSpringWithDamping: 0.2,
           initialSpringVelocity: 2.0,
           options: .allowUserInteraction,
           animations: {
               sender.transform = .identity
           },
           completion: nil)
    }
    
    func setupTabBar() {
        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = UIColor(hexString: orangeAccent)
        tabBar.shadowImage = UIImage()
        tabBar.unselectedItemTintColor = UIColor(hexString: blueAccent)
    }
    
    func configureMiddleButton() {
        if selected {
            middleBtn.tintColor = UIColor.white
            middleBtn.backgroundColor = UIColor(hexString: orangeAccent)
        } else if !selected {
            middleBtn.tintColor = UIColor.white
            middleBtn.backgroundColor = UIColor(hexString: blueAccent)
        }
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        middleBtn.layer.add(pulse, forKey: nil)
    }
}
