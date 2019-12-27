//
//  ProfileViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/24/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmChangesButton: UIButton!
    @IBOutlet weak var resetEmailButton: UIButton!

    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefillValues()
        emailTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
    }
    
    @IBAction func logout(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "goToHome", sender: nil)
            UserDefaults.standard.removeObject(forKey: "USER_KEY_UID")
            UserDefaults.standard.synchronize()
        } catch {
            alert(message: "Oops something went wrong :-(")
        }
    }
    
    
    @IBAction func resetEmailPressed(_ sender: UIButton) {
        emailTextField.isUserInteractionEnabled = true
        confirmChangesButton.isEnabled = true
        sender.isEnabled = false
    }
    
    @IBAction func confirmChangesButtonPressed(_ sender: UIButton) {
        getTextInput()
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (err) in
          if err != nil {
              self.alert(message: err!.localizedDescription)
              self.emailTextField.text = Auth.auth().currentUser!.email!
              self.emailTextField.isEnabled = false
          } else {
              Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
                  if err != nil {
                      self.alert(message: err!.localizedDescription)
                  } else {
                      self.alert(message: "A confirmation email to your new email address has been sent")
                  }
              })
            }
        })
    }
    
    @IBAction func resetPasswordPressed(_ sender: UIButton) {
        let currentUser = Auth.auth().currentUser
        Auth.auth().sendPasswordReset(withEmail: currentUser!.email!) { (err) in
            if err != nil {
                self.alert(message: err!.localizedDescription)
            } else {
                self.alert(message: "A password reset email has been sent")
            }
        }
    }
    
    func getTextInput() {
        if let email = emailTextField.text {
            self.email = email
        } else {
            self.alert(message: "Please enter a valid email address")
        }
    }
    
    func prefillValues() {
        let currentUser = Auth.auth().currentUser
        self.emailTextField.text = currentUser!.email
        self.passwordTextField.text = "**********"
    }
}
