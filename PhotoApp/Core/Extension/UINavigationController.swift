//
//  UINavigationController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/11/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    static func create<Controller>(asClass: Controller.Type) -> Controller {
        return ViewController.create(asClass: asClass)
    }
}
