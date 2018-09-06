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

class CloudRepository {
    
    private let storageRef = Storage.storage().reference().child(rootReference)
    private let databaseRef = Database.database().reference().child(rootReference)
    
    func sendPhoto(photo: Photo) {
        let photoDescriptionRef = databaseRef.childByAutoId()
        let photoDescriptionData = [category: photo.category, date: photo.date, description: photo.description]
        photoDescriptionRef.setValue(photoDescriptionData)
        
        let imageRef = storageRef.child(photo.category).child(photoDescriptionRef.key)
        guard let imageData = UIImagePNGRepresentation(photo.image) else {
            return
        }
        imageRef.putData(imageData, metadata: nil)
    }
    
    func getPhotos(callback: @escaping ([Photo]) -> ()) {
        databaseRef.observeSingleEvent(of: DataEventType.value) { [weak self] (snapshot) in
            var photos: [Photo] = []
            for idSnapshot in snapshot.children {
                if let idSnapshot = idSnapshot as? DataSnapshot, let photoDescriptionDictionary = idSnapshot.value as? [String: String] {
                    guard
                        let photoCategory = photoDescriptionDictionary[category],
                        let photoDate = photoDescriptionDictionary[date],
                        let photoDescription = photoDescriptionDictionary[description] else { return }
                    let imageRef = self?.storageRef.child(photoCategory).child(idSnapshot.key)
                    imageRef?.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        if let imageData = try? Data(contentsOf: url!) {
                            let photo = Photo(description: photoDescription, category: photoCategory, date: photoDate, image: UIImage(data: imageData)!)
                            photos.append(photo)
                            callback(photos)
                        }
                    })
                }
            }
        }
    }
}

private let rootReference = "photos"
private let category = "category"
private let date = "date"
private let description = "description"
