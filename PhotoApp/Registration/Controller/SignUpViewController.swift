//
//  SignUpViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: ViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    private let repository = SignUpRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            signUpButton.sendActions(for: .touchUpInside)
        default:
            return false
        }
        return true
    }
    
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
