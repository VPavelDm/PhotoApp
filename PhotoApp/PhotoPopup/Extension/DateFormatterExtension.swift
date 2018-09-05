//
//  StringExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension DateFormatter {
    func formatTodayDate() -> String {
        let numberFormatter = NumberFormatter()
        let today = numberFormatter.getNumberWithSuffix(number: getDateByFormat(format: "dd"))
        let currentMonth = getDateByFormat(format: "MMMM")
        let currentYearAndTime = getDateByFormat(format: "yyyy - HH:mm a").lowercased()
        return "\(currentMonth) \(today), \(currentYearAndTime)"
    }
    
    private func getDateByFormat(format: String) -> String {
        dateFormat = format
        return string(from: Date())
    }
    
}
