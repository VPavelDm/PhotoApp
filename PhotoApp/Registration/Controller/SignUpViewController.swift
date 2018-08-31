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
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    private let repository = SignUpRepository()
    
    @IBAction func clickSignUp(_ sender: UIButton) {
        guard let login = loginTF.text, let password = passwordTF.text, let confirmPassword = confirmPasswordTF.text else {
            showAlertWithError(message: "Entry login, password or confirm password text field")
            return
        }
        repository.signUp(email: login, password: password, confirmPassword: confirmPassword) { [weak self] (errorMessage) in
            if let error = errorMessage {
                self?.showAlertWithError(message: error)
            } else {
                let tabBarVC = TabBarViewController()
                self?.present(tabBarVC, animated: true, completion: nil)
            }
        }
    }
}
