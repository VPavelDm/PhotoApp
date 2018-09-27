//
//  PhotoManager.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

class TimelinePhotoDataProvider {
    // Contain photos by month and year.
    private var photosMap: [Date: [Photo]] = [:] {
        didSet {
            filteredPhotosMap = nil
        }
    }
    private var filteredPhotosMap: [Date: [Photo]]?
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
                    self?.initPhotos(photos: photos ?? [Photo]())
                }
            }
        }
    }
    
    private func initPhotos(photos: [Photo]) {
        for photo in photos {
            if categories.contains(Category(rawValue: photo.category)!) {
                if photosMap[photo.date] == nil {
                    photosMap[photo.date] = [photo]
                } else {
                    photosMap[photo.date]! += [photo]
                }
            }
        }
        delegate?.didReceivedPhotos()
    }
    
    func getMonthAndYearCount() -> Int {
        return filteredPhotosMap?.keys.count ?? photosMap.keys.count
    }
    
    func getMonthAndYear(index: Int) -> String {
        var dates: [Date] = []
        for photo in filteredPhotosMap ?? photosMap {
            dates += [photo.key]
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT
        return dateFormatter.string(from: dates.sorted()[index])
    }
    
    func getPhotoCount(by monthAndYear: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT
        let date = dateFormatter.date(from: monthAndYear)!
        return filteredPhotosMap?[date]!.count ?? photosMap[date]!.count
    }
    
    func getPhoto(monthAndYear: String, index: Int) -> Photo {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimelinePhotoDataProvider.MONTH_AND_YEAR_FORMAT
        let date = dateFormatter.date(from: monthAndYear)!
        return filteredPhotosMap?[date]![index] ?? photosMap[date]![index]
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
        delegate?.didReceivedPhotos()
    }
}
