//
//  SignUpViewController.swift
//  MyArchive
//
//  Created by Yolanda Vega on 11/4/23.
//

import UIKit

class SignUpViewController: UIViewController {
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signupButton.tintColor = activeColor
    }
    
    @IBAction func onViewTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    // Signup method
    @IBAction func onSignupTapped(_ sender: Any) {
        // Make sure all fields are non-nil and non-empty
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            print("Please fill out all fields.")
            return
        }
        // Parse user sign up
        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password
        newUser.library = []
        newUser.signup {
            [weak self] result in
            
            switch result {
            case .success(let user):
                // successful signup
                print("Successfully signed up user \(user)")
                // Posting notification that the user has successfully signed up
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
            case .failure(let error):
                // failed signup
                print("Sign Up Error: \(error)")
            }
        }
    }
    

}
