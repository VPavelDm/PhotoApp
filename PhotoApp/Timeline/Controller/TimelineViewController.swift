//
//  TimelineViewControllerTableViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/6/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBarWithCategoryButton()
        createBackgroundView()
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
        let dateFormatter = DateFormatter.templateMM_dd_yyyy
        cell.photoDateLabel.text = dateFormatter.string(from: photo.date!)
        cell.photoDescriptionLabel.text = photo.photoDescription
        cell.photoImageView.kf.setImage(with: photo.url)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
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
    
    var categories: [Category]! {
        didSet {
            timelineBackgroundView?.showActivityIndicator()
            photoManager.delegate = self
            photoManager.categories = categories
            tableView.separatorStyle = .none
            tableView.reloadData()
        }
    }
    
    private let photoManager: TimelinePhotoDataProvider = TimelinePhotoDataProvider()
    private var searchBar: UISearchBar!
    private var timelineBackgroundView: TimelineBackgroundView?
    private static let cellRowHeight = 100
    
    private func createBackgroundView() {
        timelineBackgroundView = TimelineBackgroundView()
        timelineBackgroundView?.showActivityIndicator()
        tableView.backgroundView = timelineBackgroundView
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
    

}

extension TimelineViewController: CategoryDelegate {
    
    @objc func clickCategory(_ sender: UIButton) {
        let categoryViewController = CategoryTableViewController.createController(asClass: CategoryTableViewController.self)
        categoryViewController.delegate = self
        categoryViewController.selectedCategories = categories
        let navigationViewController = UINavigationController(rootViewController: categoryViewController)
        present(navigationViewController, animated: true)
    }
    
    func choosed(categories: [Category]) {
        self.categories = categories
    }
}

extension TimelineViewController: TimelinePhotoProviderDelegate {
    func didReceivedPhotos() {
        searchBar.text = ""
        let count = photoManager.getMonthAndYearCount()
        if count > 0 {
            tableView.separatorStyle = .singleLine
            timelineBackgroundView?.stopActivityIndicator()
        } else {
            tableView.separatorStyle = .none
            timelineBackgroundView?.showNoResultLabel()
        }
        tableView.reloadData()
    }
    
    func didReceivedError(message error: String) {
        let alert = UIAlertController(message: error)
        present(alert, animated: true)
    }
}

extension TimelineViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let hashtag = searchBar.text!.isEmpty ? "" : "#\(searchBar.text!)"
        timelineBackgroundView?.showActivityIndicator()
        photoManager.filterByHashtag(hashtag)
        searchBar.resignFirstResponder()
    }
}
