//
//  ViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var lastConstraintValue: CGFloat?
    
    static func create<Controller>(storyboardId: String? = nil, asClass: Controller.Type) -> Controller {
        let storyboard = UIStoryboard(name: String(describing: asClass), bundle: nil)
        var viewController: Controller?
        if storyboardId == nil {
            viewController = storyboard.instantiateInitialViewController() as? Controller
        } else {
            viewController = storyboard.instantiateViewController(withIdentifier: storyboardId!) as? Controller
        }
        assert(viewController != nil, "Each ViewController must be initial or has identifier")
        return viewController!
    }
    
    func showAlertWithError(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error label"), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok label"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
