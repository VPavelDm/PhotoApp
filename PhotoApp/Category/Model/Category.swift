//
//  Category.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

enum Category: String {
    case NATURE
    case FRIENDS
    case DEFAULT
    
    static func category(index: Int) -> Category {
        switch index {
        case 0:
            return .NATURE
        case 1:
            return .FRIENDS
        default:
            return .DEFAULT
        }
    }
}
