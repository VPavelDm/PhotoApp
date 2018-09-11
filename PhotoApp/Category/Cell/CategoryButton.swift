//
//  CategoryButton.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/11/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class CategoryButton: UIButton {
    
    private var backgroundButtonColor: CGColor?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderWidth = 2
        let radius = frame.size.height / 2 - 3
        layer.cornerRadius = radius
        layer.borderColor = layer.backgroundColor
        backgroundButtonColor = layer.backgroundColor
    }
    
    func clickedButton() {
        isSelected = !isSelected
        if isSelected {
            layer.backgroundColor = UIColor.clear.cgColor
        } else {
            layer.backgroundColor = backgroundButtonColor
        }
    }

}
