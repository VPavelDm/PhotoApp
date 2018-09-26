//
//  ViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var lastConstraintValue: CGFloat?
    
    func getViewToScroll() -> UIView? {
        return nil
    }
    func getBottomConstraint() -> NSLayoutConstraint? {
        return nil
    }
    
}
