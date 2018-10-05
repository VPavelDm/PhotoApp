//
//  MapPhotoDataProvider.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/13/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class MapPhotoDataProvider: NSObject {
    
    private let repository = PhotoRepository()
    
    weak var delegate: MapPhotoDataProviderDelegate?
    
    var categories: [Category]? {
        didSet {
            if categories != nil {
                repository.getPhotos { [weak self] (photos, error) in
                    if let error = error {
                        self?.delegate?.didReceivedError(error: error)
                    } else {
                        self?.delegate?.didReceivedPhotos(photos: photos!)
                    }
                }
            }
        }
    }
    
}
