//
//  PhotoDetailView.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/6/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoDetailView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var rightArrowImage: UIImageView!
    @IBOutlet weak var detailStack: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let stackX = detailStack.frame.minX
            let imageRidhtX = rightArrowImage.frame.minX + rightArrowImage.frame.width + 16
            let width = imageRidhtX - stackX
            let size = CGSize(width: width, height: detailStack.frame.height)
            return size
        }
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed(String(describing: PhotoDetailView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
