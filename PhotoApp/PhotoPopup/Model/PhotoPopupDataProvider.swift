//
//  PhotoPopupDataProvider.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/14/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class PhotoPopupDataProvider {
    private let cloud = CloudRepository()
    
    func sendPhotoToTheServer(photo: Photo) {
        cloud.sendPhotoToTheServer(photo: photo)
    }
}
