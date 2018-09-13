//
//  PhotoManager.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class PhotoManager: NSObject, CloudRepositoryDelegate {
    // Contain photos by month and year. String - date representation
    private var photosMap: [String: [Photo]] = [:]
    private let cloud = CloudRepository()
    private static let MONTH_AND_YEAR_FORMAT = "MMMM dd yyyy"
    
    var categories: [Category] = Category.getAll()
    
    override init() {
        super.init()
        cloud.delegate = self
        cloud.subscribeToUpdatePhotos(categories: categories)
    }
    
    func getMonthAndYearCount() -> Int {
        return photosMap.keys.count
    }
    
    func getMonthAndYear(index: Int) -> String {
        let dateFormatter = DateFormatter()
        var dates: [Date] = []
        for photo in photosMap {
            dates += [dateFormatter.convertDate(string: photo.key, by: PhotoManager.MONTH_AND_YEAR_FORMAT)]
        }
        let dateToReturn = dates.sorted()[index]
        return dateFormatter.convertDate(date: dateToReturn, by: PhotoManager.MONTH_AND_YEAR_FORMAT)
    }
    
    func getPhotoCount(by month: String) -> Int {
        return photosMap[month]!.count
    }
    
    func getPhoto(monthAndYear: String, index: Int) -> Photo {
        return photosMap[monthAndYear]![index]
    }
    
    func photo(photo: Photo) {
        let dateFormatter = DateFormatter()
        let date = dateFormatter.convertString(string: photo.date, by: PhotoManager.MONTH_AND_YEAR_FORMAT)
        (photosMap[date] == nil) ? (photosMap[date] = [photo]) : (photosMap[date]! += [photo])
    }
    
    func error(message error: String) {
        print(error)
    }
}
