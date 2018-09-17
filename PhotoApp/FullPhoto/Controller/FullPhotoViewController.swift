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
    
    @IBAction func doubleTabOnPhoto(_ sender: Any) {
        let newZoomScale = scrollView.zoomScale + 0.5 > scrollView.maximumZoomScale ? 2.0 : scrollView.zoomScale + 0.5
        scrollView.setZoomScale(newZoomScale, animated: true)
    }
    
    @IBAction func clickBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var image: UIImage!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

}
