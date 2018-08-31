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
        Auth.auth().signIn(withEmail: loginTF.text ?? "", password: passwordTF.text ?? "") { [weak self] (authDataResult, error) in
            if let `self` = self {
                if let error = error {
                    self.showAlertWithError(message: error.localizedDescription)
                } else {
                    let tabBarVC = TabBarViewController()
                    self.present(tabBarVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func clickSignUp(_ sender: UIButton) {
        let signUpVC = SignUpViewController.create(asClass: SignUpViewController.self)
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}
