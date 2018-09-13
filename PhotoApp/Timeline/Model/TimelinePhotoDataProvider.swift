//
//  PhotoManager.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class TimelinePhotoDataProvider: NSObject, CloudRepositoryDelegate {
    // Contain photos by month and year. String - date representation
    private var photosMap: [String: [Photo]] = [:]
    private let cloud = CloudRepository()
    private static let MONTH_AND_YEAR_FORMAT = "MMMM dd yyyy"
    
    weak var delegate: PhotoManagerDelegate?
    
    var categories: [Category] = Category.getAll() {
        didSet {
            cloud.subscribeToUpdatePhotos(categories: categories)
        }
    }
    
    override init() {
        super.init()
        cloud.delegate = self
    }
    
    func getMonthAndYearCount() -> Int {
        return photosMap.keys.count
    }
    
    func getMonthAndYear(index: Int) -> String {
        let dateFormatter = DateFormatter()
        var dates: [Date] = []
        for photo in photosMap {
            dates += [dateFormatter.convertDate(string: photo.key, by: TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT)]
        }
        let dateToReturn = dates.sorted()[index]
        return dateFormatter.convertDate(date: dateToReturn, by: TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT)
    }
    
    func getPhotoCount(by month: String) -> Int {
        return photosMap[month]!.count
    }
    
    func getPhoto(monthAndYear: String, index: Int) -> Photo {
        return photosMap[monthAndYear]![index]
    }
    
    func getPhotos(monthAndYear: String?) -> [Photo] {
        if let monthAndYear = monthAndYear {
            return photosMap[monthAndYear]!
        } else {
            var resultPhotos: [Photo] = []
            for photos in photosMap.values {
                resultPhotos += photos
            }
            return resultPhotos
        }
    }
    
    func savePhoto(photo: Photo) {
        cloud.sendPhotoToTheServer(photo: photo)
    }
    
    func photo(photo: Photo) {
        let dateFormatter = DateFormatter()
        let date = dateFormatter.convertString(string: photo.date, by: TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT)
        (photosMap[date] == nil) ? (photosMap[date] = [photo]) : (photosMap[date]! += [photo])
        delegate?.photoChanged(photo: photo)
    }
    
    func error(message error: String) {
        delegate?.error(message: error)
    }
}
