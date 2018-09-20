//
//  TimelineViewControllerCategoryExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension TimelineViewController: CategoryDelegate {
    
    @objc func clickCategory(_ sender: UIButton) {
        let categoryViewController = CategoryTableViewController.create(asClass: CategoryTableViewController.self)
        categoryViewController.delegate = self
        categoryViewController.selectedCategories = categories
        let navigationViewController = UINavigationController(rootViewController: categoryViewController)
        present(navigationViewController, animated: true)
    }
    
    func choosed(categories: [Category]) {
        self.categories = categories
    }
}
