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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy - hh:mm a"
        return dateFormatter
    }
    
    class var templateMMMMddyyyyAThhmma: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
        return dateFormatter
    }
    
    class var templateMMMMddyyyy: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter
    }
    
    class var templateMM_dd_yyyy: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter
    }
}
