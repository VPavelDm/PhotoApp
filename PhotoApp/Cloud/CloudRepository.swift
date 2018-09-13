//
//  CloudRepository.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import MapKit

class CloudRepository {
    
    weak var delegate: CloudRepositoryDelegate?
    
    private static let rootReference = "photos"
    
    private let storageRef: StorageReference
    private let databaseRef: DatabaseReference
    
    init() {
        let user = Auth.auth().currentUser!
        storageRef = Storage.storage().reference().child(CloudRepository.rootReference).child(user.uid)
        databaseRef = Database.database().reference().child(CloudRepository.rootReference).child(user.uid)
    }
    
    func sendPhotoToTheServer(photo: Photo) {
        let photoDescriptionRef = databaseRef.childByAutoId()
        let photoDescriptionData: [String: Any] = [#keyPath(Photo.category): photo.category,
                                                   #keyPath(Photo.date): photo.date,
                                                   #keyPath(Photo.description): photo.photoDescription,
                                                   #keyPath(Photo.latitude): photo.latitude,
                                                   #keyPath(Photo.longitude): photo.longitude]
        
        let imageRef = storageRef.child(photo.category).child(photoDescriptionRef.key)
        guard let imageData = UIImagePNGRepresentation(photo.image) else { return }
        imageRef.putData(imageData, metadata: nil) { [weak self] (metadata, error) in
            if let error = error {
                self?.delegate?.error(message: error.localizedDescription)
            } else {
                photoDescriptionRef.setValue(photoDescriptionData)
            }
        }
    }
    
    func subscribeToUpdatePhotos(categories: [Category]) {
        databaseRef.observe(DataEventType.childAdded) { [weak self] (snapshot) in
            self?.responseHandling(snapshot, categories: categories)
        }
    }
    
    private func responseHandling(_ snapshot: DataSnapshot, categories: [Category]) {
        if var photoDescriptionDictionary = snapshot.value as? [String: Any] {
            guard let photoCategory = photoDescriptionDictionary[#keyPath(Photo.category)] as? String else { return }
            photoDescriptionDictionary["key"] = snapshot.key
            
            if categories.contains(Category(rawValue: photoCategory)!) {
                let imageRef = self.storageRef.child(photoCategory).child(snapshot.key)
                self.downloadImage(reference: imageRef) { [weak self] image in
                    photoDescriptionDictionary[#keyPath(Photo.image)] = image
                    guard let photo = self?.createPhotoByDescriptionMap(map: photoDescriptionDictionary) else { return }
                    self?.delegate?.photo(photo: photo)
                }
            }
        }
    }
    
    private func createPhotoByDescriptionMap(map photoDescriptionDictionary: [String: Any]) -> Photo? {
        guard
            let photoLatitude = photoDescriptionDictionary[#keyPath(Photo.latitude)] as? Double,
            let photoLongitude = photoDescriptionDictionary[#keyPath(Photo.longitude)] as? Double,
            let photoCategory = photoDescriptionDictionary[#keyPath(Photo.category)] as? String,
            let photoDate = photoDescriptionDictionary[#keyPath(Photo.date)] as? String,
            let photoDescription = photoDescriptionDictionary[#keyPath(Photo.description)] as? String,
            let image = photoDescriptionDictionary[#keyPath(Photo.image)] as? UIImage,
            let key = photoDescriptionDictionary["key"] as? String
            else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: photoLatitude, longitude: photoLongitude)
        return Photo(key: key, description: photoDescription, category: photoCategory, date: photoDate, image: image, coordinate: coordinate)
    }
    
    private func downloadImage(reference imageRef: StorageReference, callback: @escaping (UIImage) -> ()) {
        imageRef.downloadTestURL(completion: { (url, error) in
            guard let url = url else { return }
            if let imageData = try? Data(contentsOf: url) {
                guard let image = UIImage(data: imageData) else { return }
                callback(image)
            }
        })
    }
}

extension StorageReference {
    func downloadTestURL(completion: @escaping (_ url: URL?, _ error: Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                completion(URL(string: "https://cdn1-www.dogtime.com/assets/uploads/gallery/shiba-inu-dog-breed-picutres/thumbs/thumbs_8-side.jpg"), nil)
            }
        }
    }
}
