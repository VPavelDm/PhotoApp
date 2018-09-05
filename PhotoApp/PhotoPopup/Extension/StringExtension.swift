//
//  StringExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension String {
    func formatDate(date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = self
        return formatter.string(from: date)
    }
    func addDaySuffix() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        numberFormatter.locale = Locale.current
        return numberFormatter.string(for: Int(self))!
    }
}
