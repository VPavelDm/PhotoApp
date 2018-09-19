//
//  StringExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    func convertToString(string dateToConvert: String, to format: String, from style: Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        let date = dateFormatter.date(from: dateToConvert)!
        dateFormat = format
        return string(from: date)
    }
    
    func convertToDate(string dateToConvert: String, from style: Style) -> Date {
        dateStyle = style
        return date(from: dateToConvert)!
    }
    
    func convertToDate(string dateToConvert: String, from format: String) -> Date {
        dateFormat = format
        return date(from: dateToConvert)!
    }
    
    func convertToString(date dateToConvert: Date, to format: String) -> String {
        dateFormat = format
        return string(from: dateToConvert)
    }
    
    func convertToString(string dateToConvert: String, to style: Style, from format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: dateToConvert)!
        dateStyle = style
        return string(from: date)
    }
    
}
