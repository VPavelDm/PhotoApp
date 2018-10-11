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
    
    weak var delegate: TimelinePhotoProviderDelegate?
    
    var categories: [Category] = Category.getAll() {
        didSet {
            repository.getPhotos { [weak self] (photos, error) in
                if let error = error {
                    self?.delegate?.didReceivedError(error: error)
                } else {
                    self?.initPhotos(photos: photos ?? [Photo]())
                }
            }
        }
    }
    
    private func initPhotos(photos: [Photo]) {
        photosMap = [:]
        photos
            .filter { categories.contains(Category(rawValue: $0.category)!) }
            .forEach { photo in
                if photosMap[photo.date!] == nil {
                    photosMap[photo.date!] = [photo]
                } else {
                    photosMap[photo.date!]! += [photo]
                }
        }
        delegate?.didReceivedPhotos()
    }
    
    func getMonthAndYearCount() -> Int {
        return filteredPhotosMap?.keys.count ?? photosMap.keys.count
    }
    
    func getMonthAndYear(index: Int) -> String {
        let photosMap = filteredPhotosMap ?? self.photosMap
        let dates = photosMap.map { $0.key }.sorted { $0 > $1 }
        let dateFormatter = DateFormatter.templateMM_dd_yyyy
        return dateFormatter.string(from: dates[index])
    }
    
    func getPhotoCount(by monthAndYear: String) -> Int {
        let dateFormatter = DateFormatter.templateMM_dd_yyyy
        let date = dateFormatter.date(from: monthAndYear)!
        return filteredPhotosMap?[date]!.count ?? photosMap[date]!.count
    }
    
    func getPhoto(monthAndYear: String, index: Int) -> Photo {
        let dateFormatter = DateFormatter.templateMM_dd_yyyy
        let date = dateFormatter.date(from: monthAndYear)!
        return filteredPhotosMap?[date]![index] ?? photosMap[date]![index]
    }
    
    func filterByHashtag(_ hashtags: [String]) {
        if hashtags.count == 0 {
            filteredPhotosMap = nil
        } else {
            filteredPhotosMap = [:]
            for hashtag in hashtags {
                let resultMap = getPhotos(hashtag: hashtag)
                filteredPhotosMap!.merge(resultMap) { (aPhotos, bPhotos) -> [Photo] in
                    let aSet = Set(aPhotos)
                    let bSet = Set(bPhotos)
                    return Array(aSet.union(bSet))
                }
            }
        }
        delegate?.didReceivedPhotos()
    }
    
    private func getPhotos(hashtag: String) -> [Date: [Photo]] {
        var resultMap: [Date: [Photo]] = [:]
        photosMap.forEach { date, photos in
            let resultPhotos = photos.filter { $0.photoDescription.containsWord(hashtag) }
            if resultPhotos.count > 0 {
                resultMap[date] = resultPhotos
            }
        }
        return resultMap
    }
    
}
