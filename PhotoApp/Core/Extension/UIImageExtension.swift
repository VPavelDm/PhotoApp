//
//  UIImageExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/21/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func compress() -> Data? {
        return jpegData(compressionQuality: 0.3)
    }
}
