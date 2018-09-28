//
//  TimelineBackgrounView.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/28/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class TimelineBackgroundView: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var noResultLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        noResultLabel.isHidden = true
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()        
    }
    
    func showNoResultLabel() {
        stopActivityIndicator()
        noResultLabel.isHidden = false
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed(String(describing: TimelineBackgroundView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}
