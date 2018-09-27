//
//  TimelineViewControllerTableViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/6/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {
    
    let photoManager: TimelinePhotoDataProvider = TimelinePhotoDataProvider()
    var searchBar: UISearchBar!
    var activityIndicator: UIActivityIndicatorView!
    
    var categories: [Category]! {
        didSet {
            activityIndicator?.startAnimating()
            photoManager.delegate = self
            photoManager.categories = categories
            tableView.reloadData()
        }
    }
    
    @IBOutlet var photoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBarWithCategoryButton()
        createActivityIndicator()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return photoManager.getMonthAndYearCount()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let month = photoManager.getMonthAndYear(index: section)
        return photoManager.getPhotoCount(by: month)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return photoManager.getMonthAndYear(index: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        
        let monthAndYear = photoManager.getMonthAndYear(index: indexPath.section)
        let photo = photoManager.getPhoto(monthAndYear: monthAndYear, index: indexPath.row)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        cell.photoDateLabel.text = dateFormatter.string(from: photo.date)
        cell.photoDescriptionLabel.text = photo.photoDescription
        cell.photoImageView.image = photo.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(TimelineViewController.cellRowHeight)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monthAndYear = photoManager.getMonthAndYear(index: indexPath.section)
        let photo = photoManager.getPhoto(monthAndYear: monthAndYear, index: indexPath.row)
        let viewController = FullPhotoViewController.createController(photo: photo)
        present(viewController, animated: true)
    }
    
    private func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.color = UIColor.red
        activityIndicator.startAnimating()
        tableView.backgroundView = activityIndicator
    }
    
    private func createSearchBarWithCategoryButton() {
        searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search".localized()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        let categoryButton = UIBarButtonItem(title: "Category".localized(), style: .done, target: self, action: #selector(clickCategory))
        self.navigationItem.rightBarButtonItem = categoryButton
        
        self.navigationItem.titleView = searchBar
    }
    
    private static let cellRowHeight = 100

}
