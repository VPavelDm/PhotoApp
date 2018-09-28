//
//  PhotoDetailView.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/6/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoDetailView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var arrowImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var photoImage: UIImageView!
    
    private var photo: Photo!
    
    weak var delegate: PhotoDetailDelegate?
    
    @IBAction private func clickMarker(_ sender: Any) {
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
    
    init(photo: Photo, delegate: PhotoDetailDelegate) {
        self.init()
        self.photo = photo
        self.delegate = delegate
        initFields()
    }
    
    private func initFields() {
        let dateFormatter = DateFormatter.templateMM_dd_yyyy
        dateLabel.text = dateFormatter.string(from: photo.date)
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
