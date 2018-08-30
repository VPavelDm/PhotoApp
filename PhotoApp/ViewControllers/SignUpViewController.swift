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
    
    @IBAction func clickSignUp(_ sender: UIButton) {
        if loginTF.text == nil || passwordTF.text == nil || confirmPasswordTF.text == nil {
            showAlertWithError(message: "Entry login, password or confirm password text field")
            return
        }
        if let login = loginTF.text, let password = passwordTF.text, let confirmPassword = confirmPasswordTF.text {
            if password != confirmPassword {
                showAlertWithError(message: "Passwords do not match")
                return
            }
            Auth.auth().createUser(withEmail: login, password: password) { [unowned self] (authResult, error) in
                if let error = error {
                    self.showAlertWithError(message: error.localizedDescription)
                    return
                }
                // MARK: Add segue to MapViewController
            }
        }
    }
}
