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
    
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    
    private let repository = SignUpRepository()
    
    @IBAction private func clickSignUp(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            let alert = UIAlertController(message: "Entry login, password or confirm password text field".localized())
            present(alert, animated: true)
            return
        }
        repository.signUp(email: login, password: password, confirmPassword: confirmPassword) { [weak self] (errorMessage) in
            if let error = errorMessage {
                let alert = UIAlertController(message: error)
                self?.present(alert, animated: true)
            } else {
                let tabBarViewController = TabBarViewController()
                self?.present(tabBarViewController, animated: true, completion: nil)
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
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
}
