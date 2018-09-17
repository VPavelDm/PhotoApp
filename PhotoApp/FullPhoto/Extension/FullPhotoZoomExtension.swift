//
//  FullPhotoZoomExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension FullPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    
}
