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

    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func clickLogin(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: loginTF.text ?? "", password: passwordTF.text ?? "") { [unowned self] (authDataResult, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                // MARK: Add segue to MapViewController
            }
        }
    }
    
    @IBAction func clickSignUp(_ sender: UIButton) {
        // Mark: Add segue to SignUpViewController
    }
    
}
