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
    
    weak var delegate: PhotoPopupDelegate?
    
    private let dataProvider = PhotoPopupDataProvider()
    
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = PhotoModificationViewController.PHOTO_POPUP_DATE_FORMATTER
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
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.image = photo.image
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PhotoModificationViewController.PHOTO_POPUP_DATE_FORMATTER
        photo.category = (categoryButton.titleLabel?.text)!
        photo.date = Calendar.current.startOfDay(for: dateFormatter.date(from: dateLabel.text!) ?? Date())
        photo.photoDescription = descriptionLabel.text
        if photo.key.isEmpty {
            dataProvider.create(photo: photo) { [weak self] (photo, error) in
                if let error = error {
                    self?.delegate?.didReceivedError(error: error)
                } else {
                    self?.delegate?.photoAdded(photo: photo!)
                }
                self?.activityIndicator.stopAnimating()
                self?.dismiss(animated: true, completion: nil)
            }
        } else {
            dataProvider.update(photo: photo) { [weak self] (photo, error) in
                if let error = error {
                    self?.delegate?.didReceivedError(error: error)
                } else {
                    self?.delegate?.photoUpdated(photo: photo!)
                }
                self?.activityIndicator.stopAnimating()
                self?.dismiss(animated: true, completion: nil)
            }
        }
        view.isUserInteractionEnabled = false
        descriptionLabel.resignFirstResponder()
    }
    
    override func getViewToScroll() -> UIView? {
        return scrollView
    }
    
    override func getBottomConstraint() -> NSLayoutConstraint? {
        return bottomConstraint
    }
    
    private static let PHOTO_POPUP_DATE_FORMATTER = "MMMM dd, yyyy - hh:mm a"
    
    static func createController(photo: Photo, delegate: PhotoPopupDelegate) -> PhotoModificationViewController {
        let viewController = PhotoModificationViewController.createController(asClass: PhotoModificationViewController.self)
        viewController.photo = photo
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
