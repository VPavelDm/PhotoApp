//
//  AlertExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/13/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    convenience init(message: String) {
        self.init(title: NSLocalizedString("Error", comment: "Error label"), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok label"), style: .default, handler: nil)
        addAction(action)
    }
}
