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
    
    static func getAll() -> [Category] {
        return [.NATURE, .FRIENDS, .DEFAULT]
    }
    
    static func convert(categories: [String]?) -> [Category]? {
        guard let categories = categories else { return nil }
        var result: [Category] = []
        for category in categories {
            result += [Category(rawValue: category)!]
        }
        return result
    }
    
    static func convert(categories: [Category]) -> [String] {
        var result: [String] = []
        for category in categories {
            result += [category.rawValue]
        }
        return result
    }
}
