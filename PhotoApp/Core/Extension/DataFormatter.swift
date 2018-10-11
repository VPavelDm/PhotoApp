//
//  DataFormatter.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/28/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension DateFormatter {
    class var templateMMMMddyyyyhhmma: DateFormatter {
        return DateFormatter.create(format: "MMMM dd, yyyy - hh:mm a")
    }
    
    class var templateMMMMddyyyyAThhmma: DateFormatter {
        return DateFormatter.create(format: "MMMM dd, yyyy 'at' hh:mm a")
    }
    
    class var templateMM_dd_yyyy: DateFormatter {
        return DateFormatter.create(format: "MM-dd-yyyy")
    }
    
    private static func create(format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
}
