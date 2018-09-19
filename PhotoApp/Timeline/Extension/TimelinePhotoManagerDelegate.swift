//
//  TimelinePhotoManagerDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/13/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension TimelineViewController: TimelinePhotoProviderDelegate {
    func didReceivedPhotos() {
        tableView.reloadData()
    }
    
    func didReceivedError(message error: String) {
        let alert = UIAlertController(message: error)
        present(alert, animated: true)
    }
}
