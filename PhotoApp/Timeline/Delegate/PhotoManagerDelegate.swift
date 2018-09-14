//
//  PhotoManagerDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/13/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

protocol PhotoManagerDelegate: NSObjectProtocol {
    func photoChanged(photo: Photo)
    func error(message error: String)
}
