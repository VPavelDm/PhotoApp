//
//  InternetConnectionError.swift
//  PhotoApp
//
//  Created by mac-089-71 on 10/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class InternetConnectionError: CustomNSError {
    private let errorMessage: String = "Timeout internet connection. Turn on Internet.".localized()
    
    var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: errorMessage]
    }
}
