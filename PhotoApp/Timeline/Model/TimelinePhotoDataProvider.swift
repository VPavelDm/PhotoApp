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
    private var filteredPhotosMap: [Date: [Photo]]?
    private let cloud = CloudRepository()
    private static let MONTH_AND_YEAR_FORMAT = "MMMM dd yyyy"
    
    weak var delegate: TimelinePhotoProviderDelegate?
    
    var categories: [Category] = Category.getAll() {
        didSet {
            photosMap = [:]
            cloud.subscribeToUpdatePhotos()
        }
    }
    
    override init() {
        super.init()
        cloud.delegate = self
    }
    
    func getMonthAndYearCount() -> Int {
        return filteredPhotosMap?.count ?? photosMap.keys.count
    }
    
    func getMonthAndYear(index: Int) -> String {
        let dateFormatter = DateFormatter()
        var dates: [Date] = []
        for photo in filteredPhotosMap ?? photosMap {
            dates += [photo.key]
        }
        let dateToReturn = dates.sorted()[index]
        return dateFormatter.convertToString(date: dateToReturn, to: TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT)
    }
    
    func getPhotoCount(by monthAndYear: String) -> Int {
        let dateFormatter = DateFormatter()
        let monthAndYear = dateFormatter.convertToDate(string: monthAndYear, from: TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT)
        return filteredPhotosMap?[monthAndYear]!.count ?? photosMap[monthAndYear]!.count
    }
    
    func getPhoto(monthAndYear: String, index: Int) -> Photo {
        let dateFormatter = DateFormatter()
        let monthAndYear = dateFormatter.convertToDate(string: monthAndYear, from: TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT)
        return filteredPhotosMap?[monthAndYear]![index] ?? photosMap[monthAndYear]![index]
    }
    
    func filterByHashtag(_ hashtag: String) {
        if hashtag.isEmpty {
            filteredPhotosMap = nil
        } else {
            var resultMap: [Date: [Photo]] = [:]
            for (date, photos) in photosMap {
                var resultPhotos: [Photo] = []
                for photo in photos {
                    if photo.photoDescription.lowercased().contains(hashtag.lowercased()) {
                        resultPhotos += [photo]
                    }
                }
                if resultPhotos.count > 0 {
                    resultMap[date] = resultPhotos
                }
            }
            filteredPhotosMap = resultMap
        }
        delegate?.photoReceived()
    }
    
    func didPhotoReceived(photo: Photo) {
        let dateFormatter = DateFormatter()
        if categories.contains(Category(rawValue: photo.category)!){
            let date = dateFormatter.convertToDate(string: photo.date, from: .full)
            if photosMap[date] == nil {
                photosMap[date] = [photo]
            } else {
                guard let photos = photosMap[date] else { return }
                if !photos.contains(photo) {
                    photosMap[date]! += [photo]
                }
            }
            delegate?.photoReceived()
        }
    }
    
    func didErrorReceived(message error: String) {
        delegate?.error(message: error)
    }
}
