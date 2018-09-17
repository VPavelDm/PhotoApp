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
            photoImageView.image = photo.image
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = photo.photoDescription
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            let dateFormatter = DateFormatter()
            dateLabel.text = dateFormatter.convertToString(string: photo.date, to: FullPhotoViewController.DATE_FORMATTER, from: .full)
        }
    }
    @IBOutlet var signleTapRecognizer: UITapGestureRecognizer! {
        didSet {
            signleTapRecognizer.require(toFail: doubleTapRecognizer)
        }
    }
    @IBOutlet var doubleTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var footer: UIView!
    
    @IBAction func doubleTabOnPhoto(_ sender: Any) {
        let newZoomScale = scrollView.zoomScale + 0.5 > scrollView.maximumZoomScale ? 2.0 : scrollView.zoomScale + 0.5
        scrollView.setZoomScale(newZoomScale, animated: true)
    }
    
    @IBAction func clickBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func singleTapOnView(_ sender: Any) {
        header.isHidden = !header.isHidden
        footer.isHidden = !footer.isHidden
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var photo: Photo!
    
    private static let DATE_FORMATTER = "MMMM dd, yyyy at hh:mm a"

}
