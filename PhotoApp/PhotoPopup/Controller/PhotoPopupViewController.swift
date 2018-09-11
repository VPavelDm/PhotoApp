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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = photo.image
    }
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateLabel.text = dateFormatter.string(from: Date())
            dateLabel.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 0.7)
        }
    }
    @IBOutlet weak var categoryButton: UIButton! {
        didSet {
            categoryButton.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 0.7)
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
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
