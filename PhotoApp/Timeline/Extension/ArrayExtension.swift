//
//  ArrayExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/6/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension Array {
    func unique(by condition: (Element) -> Bool) -> [Element] {
        var unique: [Element] = []
        for element in self {
            if !condition(element) {
                unique.append(element)
            }
        }
        return unique
    }
}
