//
//  Extensions.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/25/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(message: String, title: String = "", handler: @escaping (UIAlertAction) -> Void = {_ in }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
    
    func startLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}
