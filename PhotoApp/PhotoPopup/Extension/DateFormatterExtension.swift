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
    
    func convertString(string dateToConvert: String, by format: String) -> String {
        dateStyle = .full
        let dateToReturn = date(from: dateToConvert)!
        dateFormat = format
        return string(from: dateToReturn)
    }
    
    func convertDate(string dateToConvert: String, by format: String) -> Date {
        dateFormat = format
        return date(from: dateToConvert)!
    }
    
    func convertDate(date dateToConvert: Date, by format: String) -> String {
        dateFormat = format
        return string(from: dateToConvert)
    }
    
}
