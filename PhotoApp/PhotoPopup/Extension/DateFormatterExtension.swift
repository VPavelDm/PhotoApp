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
    
    func convertDate(date: String, by format: String) -> String {
        dateStyle = .full
        let date = self.date(from: date)!
        dateFormat = format
        return string(from: date)
    }
    
}
