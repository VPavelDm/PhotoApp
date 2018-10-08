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
        let message = UIAlertController.getUserFriendlyError(message: message)
        self.init(title: "Error".localized(), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok".localized(), style: .default, handler: nil)
        addAction(action)
    }
    
    private static func getUserFriendlyError(message: String) -> String {
        var message = message
        if let index = message.firstIndex(of: "(") {
            let range = index..<message.endIndex
            message.removeSubrange(range)
        }
        return message
    }
}
