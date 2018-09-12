//
//  PhotoManager.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class PhotoManager {
    
    private var photos: [Photo] = []
    
    func getPhotos(callback: @escaping ([Photo]) -> ()) {
        
    }
    
    func getMonthAndYearCount() -> Int {
        return 0
    }
    
    func getMonthAndYear(index: Int) -> String {
        return ""
    }
    
    func getPhotoCount(by month: String) -> Int {
        return 0
    }
    
    func getPhoto(monthAndYear: String, index: Int) -> Photo {
        return photos.first!
    }
}
