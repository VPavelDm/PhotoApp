//
//  PhotoPopupViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/3/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoPopupViewController: KeyboardHandlerViewController, UITextViewDelegate {
    
    var image: UIImage?
    var delegate: PhotoPopupDelegate?
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            let dateFormatter = DateFormatter()
            dateLabel.text = dateFormatter.formatTodayDate()
            dateLabel.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 0.7)
        }
    }
    @IBOutlet weak var categoryLabel: UILabel! {
        didSet {
            categoryLabel.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 0.7)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func clickCancelButton(_ sender: UIButton) {
        descriptionTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickDoneButton(_ sender: UIButton) {
        if let image = image {
            delegate?.savePhoto(image: image)
        }
        descriptionTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            imageView.image = image
        }
    }
    
    override func getViewToScroll() -> UIView? {
        return scrollView
    }
    
    override func getBottomConstraint() -> NSLayoutConstraint? {
        return bottomConstraint
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
        }
        return true
    }
}
