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
            photoTableView?.reloadData()
        }
    }
    var categories: [Category]! {
        didSet {
            photos = []
            cloud.getPhotos(categories: categories){ [weak self] (photo) in
                self?.photos += [photo]
            }
        }
    }
    private var uniquePhotoDates: [String] = []
    private let cloud = CloudRepository()
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Category"
        }
    }
    @IBOutlet var photoTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoTableView.reloadData()
    }
    
    override func viewDidLoad() {
        createSearchBarWithCategoryButton()
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return uniquePhotoDates[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        let date = uniquePhotoDates[indexPath.section]
        let photo = photos.filter{ $0.date == date }[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        cell.photoDateLabel.text = dateFormatter.convertDate(date: photo.date, by: "MM-dd-yyyy")
        cell.photoDescriptionLabel.text = photo.photoDescription
        cell.photoImageView.image = photo.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    private func createSearchBarWithCategoryButton() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        
        let categoryButton = UIBarButtonItem(title: "Category", style: .done, target: self, action: #selector(clickCategory))
        self.navigationItem.rightBarButtonItem = categoryButton
        
        self.navigationItem.titleView = searchBar
    }
    
    @objc private func clickCategory(_ sender: UIButton) {
        let categoryViewController = CategoryTableViewController.create(storyboardId: "categoryTableViewController", asClass: CategoryTableViewController.self)
        categoryViewController.delegate = self
        categoryViewController.selectedCategories = categories
        let navigationViewController = UINavigationController(rootViewController: categoryViewController)
        let textAttributes = [NSAttributedStringKey.foregroundColor: view.tintColor!]
        navigationViewController.navigationBar.titleTextAttributes = textAttributes
        present(navigationViewController, animated: true)
    }

}
