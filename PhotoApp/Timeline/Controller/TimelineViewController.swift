//
//  TimelineViewControllerTableViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/6/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBarWithCategoryButton()
        showActivityIndicator()
    }
    
    var categories: [Category]! {
        didSet {
            showActivityIndicator()
            photoManager.delegate = self
            photoManager.categories = categories
            tableView?.separatorStyle = .none
            tableView?.reloadData()
        }
    }
    
    private let photoManager: TimelinePhotoDataProvider = TimelinePhotoDataProvider()
    private var searchBar: UISearchBar!
    private static let cellRowHeight = 100
    
    private func showNoResultLabel() {
        activityIndicator.stopAnimating()
        noResultLabel.isHidden = false
    }
    
    func showActivityIndicator() {
        activityIndicator?.startAnimating()
        noResultLabel?.isHidden = true
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
            activityIndicator.stopAnimating()
        } else {
            tableView.separatorStyle = .none
            showNoResultLabel()
        }
        tableView.reloadData()
    }
    
    func didReceivedError(error: Error) {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(message: error.getErrorDescription())
        present(alert, animated: true)
    }
}

extension TimelineViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchText = searchBar.text!
        var hashtags: [String] = []
        while searchText.startIndex != searchText.endIndex {
            let endIndex = searchText.firstIndex(of: " ") ?? searchText.endIndex
            let range = searchText.startIndex..<endIndex
            let hashtag = String(searchText[range])
            hashtags += ["#" + hashtag]
            searchText.removeSubrange(range)
            searchText = searchText.trimmingCharacters(in: .whitespaces)
        }
        showActivityIndicator()
        photoManager.filterByHashtag(hashtags)
        searchBar.resignFirstResponder()
    }
}

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return photoManager.getMonthAndYearCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let month = photoManager.getMonthAndYear(index: section)
        return photoManager.getPhotoCount(by: month)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return photoManager.getMonthAndYear(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(TimelineViewController.cellRowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let monthAndYear = photoManager.getMonthAndYear(index: indexPath.section)
        let photo = photoManager.getPhoto(monthAndYear: monthAndYear, index: indexPath.row)
        let viewController = FullPhotoViewController.createController(photo: photo)
        present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! PhotoTableViewCell
        cell.photoImageView.kf.cancelDownloadTask()
    }
}
