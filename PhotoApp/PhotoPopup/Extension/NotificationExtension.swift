//
//  NotificationExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension Notification {
    var keyboardSize: CGRect? {
        return (userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    var keyboardAnimationTime: Double? {
        return (userInfo![UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }
}
