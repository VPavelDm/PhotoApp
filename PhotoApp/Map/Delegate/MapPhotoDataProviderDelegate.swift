//
//  MapPhotoDataProviderDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/14/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

protocol MapPhotoDataProviderDelegate: NSObjectProtocol {
    func photoChanged(photo: Photo)
    func photoAdded(photo: Photo)
    func didReceivedError(message:String)

}
