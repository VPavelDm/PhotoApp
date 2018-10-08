//
//  StringExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/19/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
