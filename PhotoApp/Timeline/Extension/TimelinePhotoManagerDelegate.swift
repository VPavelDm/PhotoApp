//
//  TimelinePhotoManagerDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/13/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension TimelineViewController: TimelinePhotoProviderDelegate {
    func photoReceived() {
        tableView.reloadData()
    }
    
    func error(message error: String) {
        
    }
}
