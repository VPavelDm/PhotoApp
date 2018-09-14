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
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    var photo: Photo! {
        didSet {
            initFields()
        }
    }
    
    weak var delegate: PhotoDetailDelegate?
    
    @IBAction func clickMarker(_ sender: Any) {
        delegate?.clickedMarker(photo: photo)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func initFields() {
        let dateFormatter = DateFormatter()
        dateLabel.text = dateFormatter.convertToString(string: photo.date, to: "MM-dd-yyyy", from: .full)
        descriptionLabel.text = photo.photoDescription
        photoImage.image = photo.image
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed(String(describing: PhotoDetailView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let x = photoImage.frame.minX
            let rightX = arrowImage.frame.minX + arrowImage.frame.width
            let width = rightX - x - 16*2
            let size = CGSize(width: width, height: photoImage.frame.height)
            return size
        }
    }

}

protocol PhotoDetailDelegate: NSObjectProtocol {
    func clickedMarker(photo: Photo)
}
