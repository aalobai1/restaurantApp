//
//  SignUpViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/24/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var email: String!
    var password: String!
    var confirmedPassword: String!
    
    var currentUser: User!
    var usersStore: Users! = Users()
    var restaurants: Restaurants = Restaurants()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    @IBOutlet weak var confirmedPasswordtext: UITextField!
    
    @IBOutlet var buttonCollection: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttonCollection {
            button.layer.cornerRadius = 10
        }

        // Do any additional setup after loading the view.
    }
    
     
     @IBAction func createAnAccountPressed(_ sender: UIButton) {
         getUserInput()
         if email.count > 0 && password.count > 0 && confirmedPassword.count > 0 {
             let passwordConfirmed = checkPassword(password: password, confirmedPassword: confirmedPassword)
             if passwordConfirmed {
                 let user = User(email: email, password: password)
                 startLoading()
                 user.signUp(completion: goToNextScreen)
             }
         }
     }
     
    func goToNextScreen(error: Error?, authUser: AuthDataResult?, user: User?) {
        dismiss(animated: false) {
            if error != nil {
                self.alert(message: error!.localizedDescription, title: "Oops something wen't wrong")
            } else if authUser != nil {
               self.currentUser = user
               self.performSegue(withIdentifier: "goToHomeScreen", sender: nil)
            }
        }
     }
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          view.endEditing(true)
      }
     
    
     func getUserInput() {
         if let email = emailTextField.text,
             let password = passwordtextField.text,
             let confirmedPassword = passwordtextField.text {
                 self.email = email
                 self.password = password
                 self.confirmedPassword = confirmedPassword
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
extension SignUpViewController {
    func checkPassword(password: String, confirmedPassword: String) -> Bool {
             return password == confirmedPassword
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHomeScreen" {
            if let nextViewController = segue.destination as? ClientTabBarController {
                nextViewController.currentUser = self.currentUser
                nextViewController.usersStore = self.usersStore
                nextViewController.restaurants = self.restaurants
            }
        }
    }
}
