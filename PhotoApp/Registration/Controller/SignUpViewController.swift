//
//  SignUpViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: ViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    private let repository = SignUpRepository()
    
    @IBAction func clickSignUp(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            showAlertWithError(message: NSLocalizedString("Entry login, password or confirm password text field", comment: "Error message"))
            return
        }
        repository.signUp(email: login, password: password, confirmPassword: confirmPassword) { [weak self] (errorMessage) in
            if let error = errorMessage {
                self?.showAlertWithError(message: error)
            } else {
                let tabBarViewController = TabBarViewController()
                self?.present(tabBarViewController, animated: true, completion: nil)
            }
        }
    }
}
