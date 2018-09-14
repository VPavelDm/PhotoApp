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
    
    var categories: [Category]! {
        didSet {
            photoManager.categories = categories
        }
    }
    
    @IBOutlet var photoTableView: UITableView!
    
    override func viewDidLoad() {
        createSearchBarWithCategoryButton()
        photoManager.delegate = self
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
        
        cell.photoDateLabel.text = dateFormatter.convertToString(string: photo.date, to: "MM-dd-yyyy", from: .full)
        cell.photoDescriptionLabel.text = photo.photoDescription
        cell.photoImageView.image = photo.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(TimelineViewController.cellRowHeight)
    }
    
    private func createSearchBarWithCategoryButton() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = NSLocalizedString("Search", comment: "Searcch bar's Placeholder ")
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        let categoryButton = UIBarButtonItem(title: NSLocalizedString("Category", comment: "Category button title"), style: .done, target: self, action: #selector(clickCategory))
        self.navigationItem.rightBarButtonItem = categoryButton
        
        self.navigationItem.titleView = searchBar
    }
    
    private static let cellRowHeight = 100

}
