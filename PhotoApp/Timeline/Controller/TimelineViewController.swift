//
//  TimelineViewControllerTableViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/6/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {

    var photos: [Photo] = [] {
        didSet {
            uniquePhotoDates = []
            for photo in photos {
                if !uniquePhotoDates.contains(photo.date) {
                    uniquePhotoDates.append(photo.date)
                }
            }
        }
    }
    private var uniquePhotoDates: [String] = []
    private let cloud = CloudRepository()
    @IBOutlet var photoTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoTableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return uniquePhotoDates.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let photosByDate = photos.filter({ (photo) -> Bool in
            photo.date == uniquePhotoDates[section]
        })
        return photosByDate.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        let date = uniquePhotoDates[indexPath.section]
        let photo = photos.filter{ $0.date == date }[indexPath.row]
        cell.photoDateLabel.text = photo.date
        cell.photoDescriptionLabel.text = photo.photoDescription
        cell.photoImageView.image = photo.image
        
        cell.photoImageView.contentMode = .scaleAspectFill
        return cell
    }

}
