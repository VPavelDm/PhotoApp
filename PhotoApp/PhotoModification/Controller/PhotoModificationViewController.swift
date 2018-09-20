//
//  PhotoPopupViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/3/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoModificationViewController: ViewController {
    
    var photo: Photo!
    
    weak var delegate: PhotoPopupDelegate?
    
    private let dataProvider = PhotoPopupDataProvider()
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            let dateFormatter = DateFormatter()
            let date = photo.date.isEmpty ? Date() : dateFormatter.convertToDate(string: photo.date, from: .full)
            dateLabel.text = dateFormatter.convertToString(date: date, to: PhotoModificationViewController.PHOTO_POPUP_DATE_FORMATTER)
            dateLabel.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 0.7)
        }
    }
    @IBOutlet weak var categoryButton: UIButton! {
        didSet {
            categoryButton.setTitle(photo.category.isEmpty ? Category.DEFAULT.rawValue : photo.category, for: .normal)
            categoryButton.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 0.7)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = photo.image
        }
    }
    @IBOutlet weak var descriptionLabel: UITextView! {
        didSet {
            descriptionLabel.text = photo.photoDescription
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func clickChooseCategory(_ sender: Any) {
        let pickerViewController = PickerViewController.create(asClass: PickerViewController.self)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    @IBAction func clickCancelButton(_ sender: UIButton) {
        descriptionLabel.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickDoneButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        let dateFormatter = DateFormatter()
        photo.category = (categoryButton.titleLabel?.text)!
        photo.date = dateFormatter.convertToString(string: dateLabel.text!, to: .full, from: PhotoModificationViewController.PHOTO_POPUP_DATE_FORMATTER)
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
    
}

extension PhotoModificationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionLabel.resignFirstResponder()
        }
        return true
    }
}
