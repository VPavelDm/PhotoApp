//
//  ViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static func create<Controller>(asClass: Controller.Type) -> Controller {
        let storyboard = UIStoryboard(name: String(describing: asClass), bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as? Controller
        assert(viewController != nil, "Each ViewController must be initial")
        return viewController!
    }
    
    func showAlertWithError(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error label"), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok label"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func setRootViewController(){
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController = self
            window.makeKeyAndVisible()
        }
    }
}
