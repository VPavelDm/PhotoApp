//
//  CategoryViewControllerExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/12/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension CategoryTableViewController {
    
    func initNavigationBar() {
        navigationItem.title = NSLocalizedString("Categories", comment: "Category navigation item title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickDoneButton))
        let textAttributes = [NSAttributedStringKey.foregroundColor: view.tintColor!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
}
