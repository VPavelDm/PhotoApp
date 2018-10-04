//
//  FullPhotoViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import Kingfisher

class FullPhotoViewController: ViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 2.0
            scrollView.delegate = self
            
        }
    }
    @IBOutlet private weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.kf.setImage(with: photo.url)
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = photo.photoDescription
        }
    }
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            let dateFormatter = DateFormatter.templateMMMMddyyyyAThhmma
            dateLabel.text = dateFormatter.string(from: photo.date!)
        }
    }
    @IBOutlet private var signleTapRecognizer: UITapGestureRecognizer! {
        didSet {
            signleTapRecognizer.require(toFail: doubleTapRecognizer)
        }
    }
    @IBOutlet private var doubleTapRecognizer: UITapGestureRecognizer!
    @IBOutlet private weak var header: UIView!
    @IBOutlet private weak var footer: UIView!
    
    @IBAction private func doubleTabOnPhoto(_ sender: Any) {
        let newZoomScale = scrollView.zoomScale == scrollView.minimumZoomScale  ? scrollView.maximumZoomScale : scrollView.minimumZoomScale
        scrollView.setZoomScale(newZoomScale, animated: true)
    }
    
    @IBAction private func clickBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func singleTapOnView(_ sender: Any) {
        header.isHidden = !header.isHidden
        footer.isHidden = !footer.isHidden
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var photo: Photo!

    static func createController(photo: Photo) -> FullPhotoViewController {
        let viewController = FullPhotoViewController.createController(asClass: FullPhotoViewController.self)
        viewController.photo = photo
        return viewController
    }

}

extension FullPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}
