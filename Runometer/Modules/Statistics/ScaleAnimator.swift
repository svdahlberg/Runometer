//
//  ScaleAnimator.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class ScaleAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//        guard let toView = transitionContext.view(forKey: .to) else { return }
//        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
//        let viewToScale = presenting ? toView : fromView
//
//        let initialFrame = presenting ? originFrame : viewToScale.frame
//        let finalFrame = presenting ? viewToScale.frame : originFrame
//
//        let xScaleFactor = presenting ?
//            initialFrame.width / finalFrame.width :
//            finalFrame.width / initialFrame.width
//
//        let yScaleFactor = presenting ?
//            initialFrame.height / finalFrame.height :
//            finalFrame.height / initialFrame.height
//
//        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
//
//        if presenting {
//            viewToScale.transform = scaleTransform
//            viewToScale.center = CGPoint(
//                x: initialFrame.midX,
//                y: initialFrame.midY)
//            viewToScale.clipsToBounds = true
//        }
//
//        containerView.addSubview(toView)
//        containerView.bringSubview(toFront: viewToScale)
//
//        UIView.animate(withDuration: duration, animations: {
//            viewToScale.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
//            viewToScale.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
//        }, completion: { _ in
//            if !self.presenting {
//                self.dismissCompletion?()
//            }
//            transitionContext.completeTransition(true)
//        })
    }
}
    

