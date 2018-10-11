//
//  Category.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

enum Category: String {
    case nature = "NATURE"
    case friends = "FRIENDS"
    case default_category = "DEFAULT"
    
    static func category(index: Int) -> Category {
        switch index {
        case 0:
            return .nature
        case 1:
            return .friends
        default:
            return .default_category
        }
    }
    
    static func getAll() -> [Category] {
        return [.nature, .friends, .default_category]
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

extension Category {
    var categoryImage: UIImage {
        switch self {
        case .nature:
            return #imageLiteral(resourceName: "marker_nature")
        case .friends:
            return #imageLiteral(resourceName: "marker_friends")
        case .default_category:
            return #imageLiteral(resourceName: "marker_default")
        }
    }
}
