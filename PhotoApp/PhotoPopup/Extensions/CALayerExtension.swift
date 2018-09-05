//
//  CALayerExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

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
