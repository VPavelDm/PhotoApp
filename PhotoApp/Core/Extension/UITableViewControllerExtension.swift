//
//  UITableViewControllerExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/10/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewController {
    static func create<Controller>(storyboardId: String? = nil, asClass: Controller.Type) -> Controller {
        return ViewController.create(storyboardId: storyboardId, asClass: asClass)
    }
    
    func showAlertWithError(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error label"), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok label"), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
