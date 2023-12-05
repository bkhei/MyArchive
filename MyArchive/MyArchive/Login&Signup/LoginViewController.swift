//
//  LoginViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/6/23.
//

import UIKit

class LoginViewController: UIViewController {
    // Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginButton.tintColor = activeColor
    }
    
    @IBAction func onViewTapped(_ sender: Any) {
        view.endEditing(true)
    }

    // Action function for login -- REPLACE WITH ACTUAL ALERT
    @IBAction func onLoginTapped(_ sender: Any) {
        // Check all fields are filled (non-nil and non-empty)
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty,
              !password.isEmpty else {
            // Alert user
            print("All fields must be filled out")
            return
        }
        
        // Login the parse user via ParseSwift login() method
        User.login(username: username, password: password) {
            [weak self] result in
            
            switch result {
            case .success(let user):
                // Login successful
                print("Successfully logged in as user: \(user)")
                // Post notification
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
            case .failure(let error):
                // Login unsuccessful -- REPLACE WITH ACTUAL ERROR
                print("Login Error: \(error)")
            }
        }
    }

}
