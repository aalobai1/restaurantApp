//
//  LoginViewController.swift
//  restaurantApp
//
//  Created by Ali Alobaidi on 12/24/19.
//  Copyright © 2019 Ali Alobaidi. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    var email: String!
    var password: String!
    
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttonCollection {
            button.layer.cornerRadius = 10
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Check if the user is logged in
//        if UserDefaults.standard.object(forKey: "USER_KEY_UID") != nil {
//            let users = Users()
//            users.findUserType(withId: UserDefaults.standard.value(forKey: "USER_KEY_UID") as! String, completion: goToClientOrAdmin)
//        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        getUserInput()
        
        if email.count > 0 && password.count > 0 {
            let user = User(email: email, password: password)
            startLoading()
            user.login(completion: goToNextScreen)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func getUserInput() {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            self.email = email
            self.password = password
        }
    }
}

extension LoginViewController {
    func goToNextScreen(error: Error?, user: AuthDataResult?) {
        dismiss(animated: false, completion: nil)
        if error != nil {
            alert(message: error!.localizedDescription, title: "Oops something wen't wrong")
        } else if user != nil {
            UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "USER_KEY_UID")
            UserDefaults.standard.synchronize()
            let users = Users()
            users.findUserType(withId: user!.user.uid, completion: goToClientOrAdmin)
        }
    }
    
    func goToClientOrAdmin(type: UserType) {
        if type == .admin {
            self.performSegue(withIdentifier: "goToAdminScreen", sender: nil)
        } else if type == .client {
            self.performSegue(withIdentifier: "goToHomeScreen", sender: nil)
        }
    }
}
