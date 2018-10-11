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
        switch edge {
        case .all:
            borderWidth = thickness
            borderColor = color.cgColor
        case .bottom:
            initSublayer(frame: CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness), color: color)
        case .top:
            initSublayer(frame: CGRect(x: 0, y: 0, width: frame.width, height: thickness), color: color)
        case .right:
            initSublayer(frame: CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height), color: color)
        case .left:
            initSublayer(frame: CGRect(x: 0, y: 0, width: thickness, height: frame.height), color: color)
        default:
            break
        }
    }
    
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
    
    private func initSublayer(frame: CGRect, color: UIColor) {
        let border = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
}
