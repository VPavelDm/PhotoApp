//
//  UIViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/26/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static func createController<Controller>(asClass: Controller.Type) -> Controller {
        let storyboard = UIStoryboard(name: String(describing: asClass), bundle: nil)
        var viewController: Controller?
        viewController = storyboard.instantiateInitialViewController() as? Controller
        assert(viewController != nil, "Each ViewController must be initial")
        return viewController!
    }
}
