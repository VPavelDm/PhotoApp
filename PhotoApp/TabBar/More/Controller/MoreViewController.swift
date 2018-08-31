//
//  MoreViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import FirebaseAuth

class MoreViewController: ViewController {
        
    private let repository = MoreRepository()
    
    @IBAction func clickLogOut(_ sender: UIButton) {
        repository.signOut { [weak self] (errorMessage) in
            if let error = errorMessage {
                self?.present(UIAlertController(title: NSLocalizedString("Sign out is failure", comment: "Error message"), message: error, preferredStyle: .alert), animated: true)
            } else {
                let signInViewController = LoginViewController.create(asClass: LoginViewController.self)
                let navigation = UINavigationController(rootViewController: signInViewController)
                navigation.setRootViewController()
            }
        }
        
    }
    
}
