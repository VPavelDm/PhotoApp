//
//  PhotoPopupViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/3/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoPopupViewController: ViewController, UITextViewDelegate {
    
    var image: UIImage?
    var delegate: PhotoPopupDelegate?
    private var lastConstraintValue: CGFloat?
    
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
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    
    @IBAction func clickCancelButton(_ sender: UIButton) {
        descriptionTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickDoneButton(_ sender: UIButton) {
        if let image = image {
            delegate?.savePhoto(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            imageView.image = image
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
        }
        return true
    }
}

extension PhotoPopupViewController {
    private func getKeyboardsize(_ notification: Notification) -> CGRect? {
        return (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    private func getKeyboardAnimationTime(_ notification: Notification) -> Double? {
        return (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }
}

extension PhotoPopupViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = getKeyboardsize(notification), let keyboardAnimationTime = getKeyboardAnimationTime(notification)  {
            let scrollViewHeight = scrollView.frame.size.height
            let scrollViewBottomLeftY = scrollView.convert(CGPoint(x: 0, y: scrollViewHeight), to: nil).y
            let distanceToOffset = scrollViewBottomLeftY - keyboardSize.origin.y
            if distanceToOffset < 0 {
                return
            }
            lastConstraintValue = self.centerYConstraint.constant
            self.centerYConstraint.constant -= distanceToOffset
            UIView.animate(withDuration: keyboardAnimationTime) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let lastConstraintValue = lastConstraintValue, let keyboardAnimationTime = getKeyboardAnimationTime(notification){
            self.centerYConstraint.constant = lastConstraintValue
            UIView.animate(withDuration: keyboardAnimationTime) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
}
