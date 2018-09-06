//
//  StringExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    func getStringRepresentationOfDate(date: Date = Date(), by format: String) -> String {
        dateFormat = format
        return string(from: date)
    }
    
}
