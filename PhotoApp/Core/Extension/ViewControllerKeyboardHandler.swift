//
//  ViewControllerKeyboardHandlerExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/10/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        super.viewDidLoad()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardSize = getKeyboardsize(notification),
            let keyboardAnimationTime = getKeyboardAnimationTime(notification),
            let view = getViewToScroll(),
            let constraint = getBottomConstraint()
            else { return }
        let viewHeight = view.frame.size.height
        let viewBottomLeftY = view.convert(CGPoint(x: 0, y: viewHeight), to: nil).y
        let distanceToOffset = viewBottomLeftY - keyboardSize.origin.y
        if distanceToOffset >= 0 {
            lastConstraintValue = constraint.constant
            constraint.constant -= distanceToOffset
            UIView.animate(withDuration: keyboardAnimationTime) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard
            let keyboardAnimationTime = getKeyboardAnimationTime(notification),
            let constraint = getBottomConstraint(),
            let lastConstraintValue = lastConstraintValue
            else { return }        
        constraint.constant = lastConstraintValue
        UIView.animate(withDuration: keyboardAnimationTime) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
    }
    
    private func getKeyboardsize(_ notification: Notification) -> CGRect? {
        return (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    private func getKeyboardAnimationTime(_ notification: Notification) -> Double? {
        return (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }
}
