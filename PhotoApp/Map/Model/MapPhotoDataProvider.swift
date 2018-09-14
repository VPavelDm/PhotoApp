//
//  MapPhotoDataProvider.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/13/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class MapPhotoDataProvider: NSObject, CloudRepositoryDelegate {
    
    private let cloud = CloudRepository()
    private var photos: [Photo] = []
    
    override init() {
        super.init()
        cloud.delegate = self
    }
    
    var categories: [Category] = Category.getAll() {
        didSet {
            photos = []
            cloud.subscribeToUpdatePhotos()
        }
    }
    weak var delegate: MapPhotoDataProviderDelegate?
    
    func getPhotos() -> [Photo] {
        return photos
    }
    
    func didPhotoReceived(photo: Photo) {
        if !photos.contains(photo) {
            if categories.contains(Category(rawValue: photo.category)!){
                photos += [photo]
                delegate?.photoAdded(photo: photo)
            }
        } else {
            delegate?.photoChanged(photo: photo)
        }
    }
    
    func didErrorReceived(message error: String) {
        delegate?.didReceivedError(message: error)
    }
    
    
}
