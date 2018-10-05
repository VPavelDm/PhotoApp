//
//  Error.swift
//  PhotoApp
//
//  Created by mac-089-71 on 10/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension Error {
    func getErrorDescription() -> String {
        switch self {
        case let error as InternetConnectionError:
            return error.localizedDescription
        default:
            return self.localizedDescription
        }
    }
}
