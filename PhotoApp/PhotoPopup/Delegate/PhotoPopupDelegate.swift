//
//  PhotoPopupDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/19/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

protocol PhotoPopupDelegate: NSObjectProtocol {
    func photoAdded(photo: Photo)
    func photoUpdated(photo: Photo)
    func didReceivedError(error: Error)
}
