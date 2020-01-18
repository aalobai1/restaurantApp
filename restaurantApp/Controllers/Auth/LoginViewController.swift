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
    
    var shouldLoad = true
    
    var currentUser: User!
    var usersStore: Users! = Users()
    var restaurants = Restaurants()
    
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var stayLoggedInSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        for button in buttonCollection {
            button.layer.cornerRadius = 10
        }
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldLoad {
            checkIfUserIsLoggedIn()
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if let stayLoggedIn = UserDefaults.standard.object(forKey: "USER_STAY_LOGGED_IN") as? Bool {
            if stayLoggedIn {
                if UserDefaults.standard.object(forKey: "USER_KEY_UID") != nil {
                    startLoading()
                           let id = UserDefaults.standard.value(forKey: "USER_KEY_UID") as! String
                           usersStore.fetchUser(withId: id) { (user, err) in
                            self.dismiss(animated: false) {
                                if err != nil {
                                    self.alert(message: "Please Login Again")
                                } else {
                                    self.currentUser = user!
                                    self.goToClientOrAdmin(type: user!.type)
                                }
                              }
                           }
                       }
            } else {
                dismiss(animated: false) {
                    return
                }
            }
        } else {
            dismiss(animated: false) {
                return
            }
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        getUserInput()
        
        if email.count > 0 && password.count > 0 {
            let user = User(email: email, password: password)
            startLoading()
            user.login(completion: goToNextScreen)
        }
    }

    @IBAction func stayLoggedInSwtich(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "USER_STAY_LOGGED_IN")
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.set(false, forKey: "USER_STAY_LOGGED_IN")
            UserDefaults.standard.synchronize()
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
    func goToNextScreen(error: Error?, authUser: AuthDataResult?) {
        dismiss(animated: false) {
          if error != nil {
            self.alert(message: error!.localizedDescription, title: "Oops something wen't wrong")
          } else if authUser != nil {
//                if !authUser!.user.isEmailVerified {
//                    self.alert(message: "Please verify your email to get started")
//                } else if authUser!.user.isEmailVerified {
//                   self.saveUserDefaults()
//                   self.usersStore.fetchUser(withId: authUser!.user.uid) { (fetchedUser, err) in
//                       if (err != nil) {
//                           self.alert(message: "Something went wrong")
//                       } else {
//                           self.currentUser = fetchedUser
//                           self.goToClientOrAdmin(type: fetchedUser!.type)
//                       }
//                   }
//                }
                self.saveUserDefaults()
                self.usersStore.fetchUser(withId: authUser!.user.uid) { (fetchedUser, err) in
                    if (err != nil) {
                        self.alert(message: "Something went wrong")
                    } else {
                        self.currentUser = fetchedUser
                        self.goToClientOrAdmin(type: fetchedUser!.type)
                    }
                }
            }
        }
    }
    
    func saveUserDefaults() {
        UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "USER_KEY_UID")
        
        if stayLoggedInSwitch.isOn {
            UserDefaults.standard.set(true, forKey: "USER_STAY_LOGGED_IN")
        } else {
            UserDefaults.standard.set(false, forKey: "USER_STAY_LOGGED_IN")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func goToClientOrAdmin(type: UserType) {
        if type == .admin {
            self.performSegue(withIdentifier: "goToAdminScreen", sender: nil)
        } else if type == .client {
            self.performSegue(withIdentifier: "goToHomeScreen", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHomeScreen" {
            if let nextViewController = segue.destination as? ClientTabBarController {
                nextViewController.currentUser = self.currentUser
                nextViewController.usersStore = self.usersStore
                nextViewController.restaurants = self.restaurants
            }
        }
        else if segue.identifier == "goToAdminScreen" {
            if let nextViewController = segue.destination as? AdminTabBarController {
                nextViewController.currentUser = self.currentUser
                nextViewController.usersStore = self.usersStore
                nextViewController.restaurants = self.restaurants
            }
        }
    }
}
