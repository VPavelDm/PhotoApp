//
//  PhotoModificationAnimator.swift
//  PhotoApp
//
//  Created by mac-089-71 on 10/18/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PhotoModificationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 1.0
    var originFrame = CGRect.zero
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if presenting {
            fadeIn(containerView: containerView, using: transitionContext)
        } else {
            fadeOut(containerView: containerView, using: transitionContext)
        }
    }
    
    private func fadeIn(containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)!
        toView.alpha = 0.0
        containerView.addSubview(toView)
        
        let toViewController = transitionContext.viewController(forKey: .to) as! PhotoModificationViewController
        
        transitionContext.completeTransition(true)
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let photoImageView = toViewController.photoImageView!
            
            //Initialize the image to be transferred
            let imageView = UIImageView(image: photoImageView.image)
            imageView.frame = self.originFrame
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            containerView.addSubview(imageView)
            containerView.bringSubviewToFront(imageView)
            
            //Get final position of image
            let finalFrame = photoImageView.superview!.convert(photoImageView.frame, to: toView)
            
            toViewController.photoImageView.alpha = 0.0
            
            UIView.animate(withDuration: self.duration, animations: {
                imageView.frame = finalFrame
                toView.alpha = 1.0
            }, completion: {(_) in
                imageView.removeFromSuperview()
                toViewController.photoImageView.alpha = 1.0
            })
        }
    }
    
    private func fadeOut(containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!

        UIView.animate(withDuration: duration, animations: {
            fromView.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    

}
