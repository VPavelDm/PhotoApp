//
//  PhotoPopupDataProvider.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/14/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

class PhotoPopupDataProvider {
    private let repository = PhotoRepository()
    
    func create(photo: Photo, image: UIImage, callback: @escaping (Photo?, Error?) -> ()) {
        repository.create(photo: photo, image: image, callback: callback)
    }
    
    func update(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        repository.update(photo: photo, callback: callback)
    }
}
