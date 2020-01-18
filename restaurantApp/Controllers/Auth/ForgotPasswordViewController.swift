//
//  ForgotPasswordViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 1/5/20.
//  Copyright © 2020 Ali Alobaidi. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if let email = emailAddressTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { (err) in
                if err != nil {
                    self.alert(message: err!.localizedDescription)
                } else {
                    self.alert(message: "A password reset email has been sent!")
                }
            }
        } else {
            self.alert(message: "Please enter your email")
        }
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
