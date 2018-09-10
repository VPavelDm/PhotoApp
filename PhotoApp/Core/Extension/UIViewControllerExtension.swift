//
//  UIViewControllerExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/10/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setRootViewController(){
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController = self
            window.makeKeyAndVisible()
        }
    }
}
