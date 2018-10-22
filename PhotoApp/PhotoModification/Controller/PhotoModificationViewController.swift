//
//  PhotoPopupViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/3/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoModificationViewController: ViewController {
    
    private var photo: Photo!
    private var image: UIImage?
    let transition = PhotoModificationAnimator()
    var selectedMarker: UIImageView?
    
    weak var delegate: PhotoPopupDelegate?
    
    private let dataProvider = PhotoPopupDataProvider()
    
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            let dateFormatter = DateFormatter.templateMMMMddyyyyhhmma
            dateLabel.text = dateFormatter.string(from: photo.date ?? Date())
            dateLabel.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 0.7)
        }
    }
    @IBOutlet private weak var categoryButton: UIButton! {
        didSet {
            categoryButton.setTitle(photo.category.isEmpty ? Category.default_category.rawValue : photo.category, for: .normal)
            categoryButton.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 0.7)
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            if let image = image {
                photoImageView.image = image
            } else {
                photoImageView.kf.indicatorType = .activity
                photoImageView.kf.setImage(with: photo.url)
            }
        }
    }
    @IBOutlet private weak var descriptionLabel: UITextView! {
        didSet {
            descriptionLabel.text = photo.photoDescription
        }
    }
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction private func clickChooseCategory(_ sender: Any) {
        let pickerViewController = PickerViewController.createController(asClass: PickerViewController.self)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    @IBAction private func clickCancelButton(_ sender: UIButton) {
        descriptionLabel.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func clickDoneButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        let dateFormatter = DateFormatter.templateMMMMddyyyyhhmma
        photo.category = (categoryButton.titleLabel?.text)!
        photo.date = Calendar.current.startOfDay(for: dateFormatter.date(from: dateLabel.text!) ?? Date())
        photo.photoDescription = descriptionLabel.text
        // If image is setted user is trying to create photo. Other way user wants to update information
        if let image = image, photo.key.isEmpty {
            dataProvider.create(photo: photo, image: image) { [weak self] (photo, error) in
                self?.dismiss(animated: true) { [weak self] in
                    if let error = error {
                        self?.delegate?.didReceivedError(error: error)
                    } else {
                        self?.delegate?.photoAdded(photo: photo!)
                    }
                }
                self?.activityIndicator.stopAnimating()
            }
        } else {
            dataProvider.update(photo: photo) { [weak self] (photo, error) in
                self?.dismiss(animated: true) { [weak self] in
                    if let error = error {
                        self?.delegate?.didReceivedError(error: error)
                    } else {
                        self?.delegate?.photoUpdated(photo: photo!)
                    }
                }
                self?.activityIndicator.stopAnimating()
            }
        }
        view.isUserInteractionEnabled = false
        descriptionLabel.resignFirstResponder()
    }
    @IBAction func clickPhotoImage(_ sender: Any) {
        let viewController = FullPhotoViewController.createController(photo: photo)
        present(viewController, animated: true)
    }
    
    override func getViewToScroll() -> UIView? {
        return scrollView
    }
    
    override func getBottomConstraint() -> NSLayoutConstraint? {
        return bottomConstraint
    }
    
    static func createController(photo: Photo, image: UIImage?, delegate: PhotoPopupDelegate) -> PhotoModificationViewController {
        let viewController = PhotoModificationViewController.createController(asClass: PhotoModificationViewController.self)
        viewController.photo = photo
        viewController.image = image
        viewController.delegate = delegate
        return viewController
    }
    
}

extension PhotoModificationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionLabel.resignFirstResponder()
        }
        return true
    }
}

extension PhotoModificationViewController: PickerDelegate {
    func chooseCategory(category: String) {
        categoryButton.setTitle(category, for: .normal)
    }
}

extension PhotoModificationViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedMarker!.convert(selectedMarker!.frame, to: nil)
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
