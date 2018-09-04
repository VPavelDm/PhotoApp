//
//  LoginViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: ViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let repository = LoginRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func clickLogin(_ sender: UIButton) {
        repository.signIn(email: loginTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] error in
            if let error = error {
                self?.showAlertWithError(message: error)
            } else {
                let tabBarViewController = TabBarViewController()
                self?.present(tabBarViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func clickSignUp(_ sender: UIButton) {
        let signUpViewController = SignUpViewController.create(asClass: SignUpViewController.self)
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
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
