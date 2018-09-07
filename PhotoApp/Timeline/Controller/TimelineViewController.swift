//
//  TimelineViewControllerTableViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/6/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {

    private let cloud = CloudRepository()
    private var photos: [Photo] = []
    private var uniquePhotoDates: [String] = []
    @IBOutlet var photoTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.cloud.getPhotos { [weak self] (photo) in
                if let `self` = self {
                    if !self.photos.contains(where: { (photoToCheck) -> Bool in
                        return photoToCheck.key == photo.key
                    }){
                        self.photos.append(photo)
                        if !self.uniquePhotoDates.contains(photo.date) {
                            self.uniquePhotoDates.append(photo.date)
                        }
                        DispatchQueue.main.async {
                            self.photoTableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return uniquePhotoDates.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
//        return photos.filter{ $0.date == uniquePhotoDates[section] }.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        cell.photoDateLabel.text = photos[indexPath.row].date
        cell.photoDescriptionLabel.text = photos[indexPath.row].description
//        cell.photoImageView.image = photos[indexPath.row].image
        
        cell.photoImageView.contentMode = .scaleAspectFill
        return cell
    }

}
