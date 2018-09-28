//
//  LoginViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: ViewController {
    
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let repository = LoginRepository()
    
    @IBAction private func clickLogin(_ sender: UIButton) {
        activityIndicator.startAnimating()
        repository.signIn(email: loginTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] error in
            self?.activityIndicator.stopAnimating()
            if let error = error {
                let alert = UIAlertController(message: error)
                self?.present(alert, animated: true, completion: nil)
            } else {
                let tabBarViewController = TabBarViewController()
                self?.present(tabBarViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction private func clickSignUp(_ sender: UIButton) {
        let signUpViewController = SignUpViewController.createController(asClass: SignUpViewController.self)
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            loginButton.sendActions(for: .touchUpInside)
        default:
            return false
        }
        return true
    }
}
