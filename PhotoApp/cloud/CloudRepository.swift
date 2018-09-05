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
    private let storageRef = Storage.storage().reference()
    private let dbRef = Database.database().reference()
    
    func sendPhoto(photo: Photo) {
        let photoKey = dbRef.child("photos/").childByAutoId().key
        let photoRef = dbRef.child("photos/").child(photoKey)
        let photoData = ["category" : photo.category, "date" : photo.date, "description" : photo.description]
        photoRef.setValue(photoData)
        let imageRef = storageRef.child("images/\(photo.category)/\(photoKey)")
        guard let imageData = UIImagePNGRepresentation(photo.image) else {
            return
        }
        imageRef.putData(imageData, metadata: nil) { (_, error) in
            imageRef.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    print("Smth went wrong!")
                    return
                }
                print("url: \(url)")
            })
        }
        
    }
    
//    func getPhoto() {
//        let photosRef = dbRef.child("photos/")
//        photosRef.observeSingleEvent(of: DataEventType.value) { (snapshot) in
//            for idSnapshot in snapshot.children {
//                if let idSnapshot = idSnapshot as? DataSnapshot, let photo = idSnapshot.value as? [String : String] {
//                    let storageRef = Storage.storage().reference()
//                    var imageRef = storageRef.child("images/")
//                    imageRef = imageRef.child(photo["category"]!)
//                    imageRef = imageRef.child(idSnapshot.key)
//                    imageRef.downloadURL(completion: { (url, error) in
//                        if let url = url {
//                            let image = UIImage(contentsOfFile: url)
//                        }
//                    })
//                }
//            }
//        }
//    }
}
