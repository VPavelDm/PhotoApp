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
        self.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "ic_more"), tag: 3)
    }
    
    @IBAction func clickLogOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let signInVC = LoginViewController.create(asClass: LoginViewController.self)
            let navigation = UINavigationController(rootViewController: signInVC)
            navigation.setRootViewController()
        } catch let error {
            self.present(UIAlertController(title: "Sign out is failure", message: error.localizedDescription, preferredStyle: .alert), animated: true)
        }
    }
    
}
