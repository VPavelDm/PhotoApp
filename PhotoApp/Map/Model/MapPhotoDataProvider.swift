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
            cloud.subscribeToUpdatePhotos(categories: categories)
        }
    }
    weak var delegate: PhotoManagerDelegate?
    
    func getPhotos() -> [Photo] {
        return photos
    }
    
    func didPhotoReceived(photo: Photo) {
        photos += [photo]
        delegate?.photoChanged(photo: photo)
    }
    
    func didErrorReceived(message error: String) {
        delegate?.error(message: error)
    }
    
    
}
