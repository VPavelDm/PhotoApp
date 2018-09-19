//
//  NumberFormatterExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension NumberFormatter {
    func getNumberWithSuffix(number: String) -> String {
        numberStyle = .ordinal
        locale = Locale.current
        return string(for: Int(number))!
    }
}
