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

}
