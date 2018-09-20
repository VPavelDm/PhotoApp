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

class PhotoRepository {
    
    private static let rootReference = "photos"
    
    private let storageRef: StorageReference
    private let databaseRef: DatabaseReference
    
    init() {
        let user = Auth.auth().currentUser!
        storageRef = Storage.storage().reference().child(PhotoRepository.rootReference).child(user.uid)
        databaseRef = Database.database().reference().child(PhotoRepository.rootReference).child(user.uid)
    }

    func create(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        let photoDescriptionRef = databaseRef.childByAutoId()
        let photoDescriptionData = photo.toMap(key: photoDescriptionRef.key)
        let imageRef = storageRef.child(photo.category).child(photoDescriptionRef.key)
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData = photo.image.pngData() else { return }
            DispatchQueue.main.async {
                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        callback(nil, error)
                    } else {
                        photoDescriptionRef.setValue(photoDescriptionData, withCompletionBlock: { (error, dbRef) in
                            if let error = error {
                                callback(nil, error)
                            } else {
                                callback(photo, error)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func update(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            let photoDescriptionRef = self.databaseRef.child(photo.key)
            let photoDescriptionData: [String: Any] = photo.toMap(key: photo.key)
            photoDescriptionRef.setValue(photoDescriptionData) { (error, dbRef) in
                DispatchQueue.main.async {
                    if let error = error {
                        callback(nil, error)
                    } else {
                        callback(photo, error)
                    }
                }
            }
        }
    }
    
    func getPhotos(callback: @escaping ([Photo]?, Error?) -> ()) {
        var photos: [Photo] = []
        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childrenCount == 0 {
                callback(photos, nil)                
            }
            for photoSnapshot in snapshot.children {
                //MARK: refactor
                if let photoSnapshot = photoSnapshot as? DataSnapshot, var photoDescriptionDictionary = photoSnapshot.value as? [String: Any] {
                    guard let photoCategory = photoDescriptionDictionary[#keyPath(Photo.category)] as? String else { return }
                    photoDescriptionDictionary[#keyPath(DataSnapshot.key)] = photoSnapshot.key
                    let imageRef = self.storageRef.child(photoCategory).child(photoSnapshot.key)
                    self.downloadImage(reference: imageRef) { [weak self] image in
                        photoDescriptionDictionary[#keyPath(Photo.image)] = image
                        guard let photo = self?.createPhotoByDescriptionMap(map: photoDescriptionDictionary) else { return }
                        photos += [photo]
                        if photos.count == snapshot.childrenCount {
                            callback(photos, nil)
                        }
                    }
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
            let key = photoDescriptionDictionary[#keyPath(DataSnapshot.key)] as? String
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
