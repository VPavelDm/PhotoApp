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
        let photoDescriptionRef: DatabaseReference
        if photo.key.isEmpty {
            photoDescriptionRef = databaseRef.childByAutoId()
        } else {
            photoDescriptionRef = databaseRef.child(photo.key)
        }
        let photoDescriptionData: [String: Any] = [#keyPath(Photo.category): photo.category,
                                                   #keyPath(Photo.date): photo.date,
                                                   #keyPath(Photo.description): photo.photoDescription,
                                                   #keyPath(Photo.latitude): photo.latitude,
                                                   #keyPath(Photo.longitude): photo.longitude]
        if photo.key.isEmpty {
            let imageRef = storageRef.child(photo.category).child(photoDescriptionRef.key)
            guard let imageData = photo.image.pngData() else { return }
            imageRef.putData(imageData, metadata: nil) { [weak self] (metadata, error) in
                if let error = error {
                    self?.delegate?.didErrorReceived(message: error.localizedDescription)
                } else {
                    photoDescriptionRef.setValue(photoDescriptionData)
                }
            }
        } else {
            photoDescriptionRef.setValue(photoDescriptionData)
        }
    }
    
    func subscribeToUpdatePhotos() {
        databaseRef.removeAllObservers()
        databaseRef.observe(DataEventType.childAdded) { [weak self] (snapshot) in
            self?.responseHandling(snapshot)
        }
        databaseRef.observe(DataEventType.childChanged) { [weak self] (snapshot) in
            self?.responseHandling(snapshot)
        }
    }
    
    private func responseHandling(_ snapshot: DataSnapshot) {
        if var photoDescriptionDictionary = snapshot.value as? [String: Any] {
            guard let photoCategory = photoDescriptionDictionary[#keyPath(Photo.category)] as? String else { return }
            photoDescriptionDictionary["key"] = snapshot.key
            let imageRef = self.storageRef.child(photoCategory).child(snapshot.key)
            self.downloadImage(reference: imageRef) { [weak self] image in
                photoDescriptionDictionary[#keyPath(Photo.image)] = image
                guard let photo = self?.createPhotoByDescriptionMap(map: photoDescriptionDictionary) else { return }
                self?.delegate?.didPhotoReceived(photo: photo)
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
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    guard let image = UIImage(data: imageData) else { return }
                    DispatchQueue.main.async {
                        callback(image)
                    }
                }
            }
        })
    }
}

extension StorageReference {
    func downloadTestURL(completion: @escaping (_ url: URL?, _ error: Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                completion(URL(string: "https://sobaki.guru/wp-content/uploads/2018/01/siba_inu_29_19121837.jpg"), nil)
            }
        }
    }
}
