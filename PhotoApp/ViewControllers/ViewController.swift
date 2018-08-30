//
//  ViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static func create<Controller>(asClass: Controller.Type) -> UIViewController {
        let storyboard = UIStoryboard(name: String(describing: Controller.self), bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        assert(viewController != nil, "Each ViewController must be initial")
        return viewController!
    }
    
    func showAlertWithError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
