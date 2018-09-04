//
//  PhotoPopupViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/3/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoPopupViewController: ViewController, UITextViewDelegate {
    
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
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            imageView.image = image
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func clickCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
