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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "ic_more"), tag: 3)
    }
    
    private let repository = MoreRepository()
    
    @IBAction func clickLogOut(_ sender: UIButton) {
        repository.signOut { [weak self] (errorMessage) in
            if let error = errorMessage {
                self?.present(UIAlertController(title: "Sign out is failure", message: error, preferredStyle: .alert), animated: true)
            } else {
                let signInVC = LoginViewController.create(asClass: LoginViewController.self)
                let navigation = UINavigationController(rootViewController: signInVC)
                navigation.setRootViewController()
            }
        }
        
    }
    
}
