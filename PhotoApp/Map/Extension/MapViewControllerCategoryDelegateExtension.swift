//
//  MapViewControllerCategoryDelegateExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/11/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension MapViewController: CategoryDelegate {
    func choosed(categories: [Category]) {
        self.categories = categories
    }
}
