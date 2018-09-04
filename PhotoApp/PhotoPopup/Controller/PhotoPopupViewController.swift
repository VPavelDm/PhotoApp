//
//  PhotoPopupViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/3/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoPopupViewController: ViewController {
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            let today = "dd".formatDate().addDaySuffix()
            let currentMonth = "MMMM".formatDate()
            let currentYearAndTime = "yyyy - HH:mm a".formatDate().lowercased()
            dateLabel.text = "\(currentMonth) \(today), \(currentYearAndTime)"
            dateLabel.layer.addBorder(color: UIColor.black, thickness: 0.7)
        }
    }
    @IBOutlet weak var categoryLabel: UILabel! {
        didSet {
            categoryLabel.layer.addBorder(color: UIColor.black, thickness: 0.7)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            imageView.image = image
        } else {
            imageView.backgroundColor = UIColor.cyan
        }
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
}

extension String {
    func addDaySuffix() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        numberFormatter.locale = Locale.current
        return numberFormatter.string(for: Int(self))!
    }
}

extension CALayer {
    
    func addBorder(color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}
