//
//  CloudRepositoryDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

protocol CloudRepositoryDelegate: NSObjectProtocol {
    func photo(photo: Photo)
    func error(message error: String)
}
