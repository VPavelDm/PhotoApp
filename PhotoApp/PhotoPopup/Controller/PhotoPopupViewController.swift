//
//  PhotoPopupViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/3/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoPopupViewController: ViewController {
    
    var photo: Photo!
    weak var delegate: PhotoPopupDelegate?
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            let dateFormatter = DateFormatter()
            let date = photo.date.isEmpty ? Date() : dateFormatter.convertDate(string: photo.date, by: .full)
            dateLabel.text = dateFormatter.convertDate(date: date, by: "MMMM dd, yyyy - hh:mm a")
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
        photo.category = (categoryButton.titleLabel?.text)!
        photo.date = dateLabel.text!
        photo.photoDescription = descriptionLabel.text
        delegate?.savePhoto(photo: photo)
        
        descriptionLabel.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    override func getViewToScroll() -> UIView? {
        return scrollView
    }
    
    override func getBottomConstraint() -> NSLayoutConstraint? {
        return bottomConstraint
    }
    
}

extension PhotoPopupViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionLabel.resignFirstResponder()
        }
        return true
    }
}
