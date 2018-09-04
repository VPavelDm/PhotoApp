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
    private var lastConstraintValue: CGFloat?
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            let today = "dd".formatDate().addDaySuffix()
            let currentMonth = "MMMM".formatDate()
            let currentYearAndTime = "yyyy - HH:mm a".formatDate().lowercased()
            dateLabel.text = "\(currentMonth) \(today), \(currentYearAndTime)"
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
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = notification.keyboardSize, let keyboardAnimationTime = notification.keyboardAnimationTime  {
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
        if let lastConstraintValue = lastConstraintValue, let keyboardAnimationTime = notification.keyboardAnimationTime {
            self.centerYConstraint.constant = lastConstraintValue
            UIView.animate(withDuration: keyboardAnimationTime) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
}

extension Notification {
    var keyboardSize: CGRect? {
        return (userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    var keyboardAnimationTime: Double? {
        return (userInfo![UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }
}

extension String {
    func formatDate(date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = self
        return formatter.string(from: date)
    }
    func addDaySuffix() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        numberFormatter.locale = Locale.current
        return numberFormatter.string(for: Int(self))!
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case .all:
            borderWidth = thickness
            borderColor = color.cgColor
            return
        case .bottom: border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .top: border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .right: border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        case .left: border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        default: break
        }
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
    
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}
