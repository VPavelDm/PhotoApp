//
//  FullPhotoViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class FullPhotoViewController: ViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.5
            scrollView.maximumZoomScale = 2.0
            scrollView.delegate = self
            
        }
    }
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.image = image
        }
    }
    
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    

}
