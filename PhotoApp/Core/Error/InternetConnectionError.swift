//
//  InternetConnectionError.swift
//  PhotoApp
//
//  Created by mac-089-71 on 10/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

enum InternetConnectionError: Error {
    case timeoutException
    var localizedDescription: String {
        switch self {
        case .timeoutException:
            return "Timeout internet connection. Re-turn wi-fi."
        }
    }
}
