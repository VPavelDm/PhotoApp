//
//  TimelineSearchDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/14/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension TimelineViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let hashtag = searchBar.text!.isEmpty ? "" : "#\(searchBar.text!)"
        photoManager.filterByHashtag(hashtag)
        searchBar.resignFirstResponder()
    }
}
