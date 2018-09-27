//
//  PhotoManager.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class TimelinePhotoDataProvider: NSObject {
    // Contain photos by month and year. String - date representation
    private var photosMap: [String: [Photo]] = [:] {
        didSet {
            filteredPhotosMap = nil
        }
    }
    private var filteredPhotosMap: [String: [Photo]]?
    private let repository = PhotoRepository()
    private static let MONTH_AND_YEAR_FORMAT = "MMMM dd yyyy"
    
    weak var delegate: TimelinePhotoProviderDelegate?
    
    var categories: [Category] = Category.getAll() {
        didSet {
            photosMap = [:]
            repository.getPhotos { [weak self] (photos, error) in
                if let error = error {
                    self?.delegate?.didReceivedError(message: error.localizedDescription)
                } else {
                    guard let `self` = self else { return }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT
                    for photo in photos! {
                        if self.categories.contains(Category(rawValue: photo.category)!) {
                            let date = dateFormatter.string(from: photo.date)
                            if self.photosMap[date] == nil {
                                self.photosMap[date] = [photo]
                            } else {
                                self.photosMap[date]! += [photo]
                            }
                        }
                    }
                    self.delegate?.didReceivedPhotos()
                }
            }
        }
    }
    
    func getMonthAndYearCount() -> Int {
        return filteredPhotosMap?.keys.count ?? photosMap.keys.count
    }
    
    func getMonthAndYear(index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT
        var dates: [Date] = []
        for photo in filteredPhotosMap ?? photosMap {
            let date = dateFormatter.date(from: photo.key)!
            dates += [date]
        }
        let dateToReturn = dates.sorted()[index]
        return dateFormatter.string(from: dateToReturn)
    }
    
    func getPhotoCount(by monthAndYear: String) -> Int {
        return filteredPhotosMap?[monthAndYear]!.count ?? photosMap[monthAndYear]!.count
    }
    
    func getPhoto(monthAndYear: String, index: Int) -> Photo {
        return filteredPhotosMap?[monthAndYear]![index] ?? photosMap[monthAndYear]![index]
    }
    
    func filterByHashtag(_ hashtag: String) {
        if hashtag.isEmpty {
            filteredPhotosMap = nil
        } else {
            var resultMap: [String: [Photo]] = [:]
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
        delegate?.didReceivedPhotos()
    }
}
