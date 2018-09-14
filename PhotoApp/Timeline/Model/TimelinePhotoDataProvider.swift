//
//  PhotoManager.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class TimelinePhotoDataProvider: NSObject, CloudRepositoryDelegate {
    // Contain photos by month and year.
    private var photosMap: [Date: [Photo]] = [:]
    private let cloud = CloudRepository()
    private static let MONTH_AND_YEAR_FORMAT = "MMMM dd yyyy"
    
    weak var delegate: TimelinePhotoProviderDelegate?
    
    var categories: [Category] = Category.getAll() {
        didSet {
            photosMap = [:]
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
            dates += [photo.key]
        }
        let dateToReturn = dates.sorted()[index]
        return dateFormatter.convertToString(date: dateToReturn, to: TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT)
    }
    
    func getPhotoCount(by monthAndYear: String) -> Int {
        let dateFormatter = DateFormatter()
        let monthAndYear = dateFormatter.convertToDate(string: monthAndYear, from: TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT)
        return photosMap[monthAndYear]!.count
    }
    
    func getPhoto(monthAndYear: String, index: Int) -> Photo {
        let dateFormatter = DateFormatter()
        let monthAndYear = dateFormatter.convertToDate(string: monthAndYear, from: TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT)
        return photosMap[monthAndYear]![index]
    }
    
    func didPhotoReceived(photo: Photo) {
        let dateFormatter = DateFormatter()
        let date = dateFormatter.convertToDate(string: photo.date, from: .full)
        if photosMap[date] == nil {
            photosMap[date] = [photo]
        } else {
            guard let photos = photosMap[date] else { return }
            if !photos.contains(photo) {
                photosMap[date]! += [photo]
            }
        }
        delegate?.photoReceived(photo: photo)
    }
    
    func didErrorReceived(message error: String) {
        delegate?.error(message: error)
    }
}
