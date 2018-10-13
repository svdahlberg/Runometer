//
//  ScalingTransition.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

protocol RunStatisticsDetailTransitionViewController: class {
    func runStatisticsView() -> RunStatisticView
    func backgroundView() -> UIView
}

class RunStatisticsDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    
    private let statisticsCell: RunStatisticCollectionViewCell
    private lazy var statisticsView: RunStatisticView = statisticsCell.runStatisticView
    private lazy var backgroundView: UIView = statisticsCell.backgroundColorView
    
    init(statisticsCell: RunStatisticCollectionViewCell) {
        self.statisticsCell = statisticsCell
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let statisticsViews = statisticsViews(transitionContext: transitionContext),
            let backgroundViews = backgroundViews(transitionContext: transitionContext)
        else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        statisticsViews.initial.alpha = 0
        statisticsViews.final.alpha = 0
        backgroundViews.initial.alpha = 0
        backgroundViews.final.alpha = 0
        toView.alpha = 0
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        
        containerView.layoutIfNeeded()
        
        // Add backgroundView to containerView
        guard let initialBackgroundViewSuperView = backgroundViews.initial.superview,
            let finalBackgroundViewSuperView = backgroundViews.final.superview else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        
        let finalBackgroundFrameInContainerView = containerView.convert(backgroundViews.final.frame, from: finalBackgroundViewSuperView)
        let initialBackgroundCenterInContainerView = containerView.convert(backgroundViews.initial.center, from: initialBackgroundViewSuperView)
        let animatableBackgroundView = UIView(frame: backgroundViews.initial.frame)
        animatableBackgroundView.backgroundColor = backgroundViews.initial.backgroundColor
        containerView.addSubview(animatableBackgroundView)
        animatableBackgroundView.center = initialBackgroundCenterInContainerView
        
        // Add statisticsView to containerView
        guard let initialStatisticViewSuperView = statisticsViews.initial.superview,
            let finalStatisticViewSuperView = statisticsViews.final.superview else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        let finalFrameInContainerView = containerView.convert(statisticsViews.final.frame, from: finalStatisticViewSuperView)
        let initialCenterInContainerView = containerView.convert(statisticsViews.initial.center, from: initialStatisticViewSuperView)
        let animatableStatisticsView = RunStatisticView(frame: finalFrameInContainerView)
        animatableStatisticsView.statistic = statisticsViews.initial.statistic
        containerView.addSubview(animatableStatisticsView)
        animatableStatisticsView.center = initialCenterInContainerView
        
        let isPresenting = transitionContext.viewController(forKey: .to) is RunStatisticDetailViewController
        UIViewPropertyAnimator(duration: duration, curve: .linear) {
            animatableBackgroundView.layer.cornerRadius = isPresenting ? 0 : self.statisticsCell.layer.cornerRadius
        }.startAnimation()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, animations: {
            
            toView.alpha = 1
            fromView.alpha = 0

            if isPresenting {
                animatableBackgroundView.frame = backgroundViews.final.frame
                animatableStatisticsView.frame = statisticsViews.final.frame
            } else {
                animatableBackgroundView.frame = finalBackgroundFrameInContainerView
                animatableStatisticsView.frame = finalFrameInContainerView
            }
            
        }) { (_) in
            statisticsViews.final.alpha = 1
            backgroundViews.final.alpha = 1
            animatableStatisticsView.removeFromSuperview()
            animatableBackgroundView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    private func statisticsViews(transitionContext: UIViewControllerContextTransitioning) -> (initial: RunStatisticView, final: RunStatisticView)? {
        guard let detailsViewController = transitionContext.viewController(forKey: .to) as? RunStatisticsDetailTransitionViewController else {
            guard let detailsViewController = transitionContext.viewController(forKey: .from) as? RunStatisticsDetailTransitionViewController else {
                return nil
            }
            
            return (initial: detailsViewController.runStatisticsView(), final: statisticsView)
        }
        
        return (initial: statisticsView, final: detailsViewController.runStatisticsView())
    }

    private func backgroundViews(transitionContext: UIViewControllerContextTransitioning) -> (initial: UIView, final: UIView)? {
        guard let detailsViewController = transitionContext.viewController(forKey: .to) as? RunStatisticsDetailTransitionViewController else {
            guard let detailsViewController = transitionContext.viewController(forKey: .from) as? RunStatisticsDetailTransitionViewController else {
                return nil
            }
            
            return (initial: detailsViewController.backgroundView(), final: backgroundView)
        }
        
        return (initial: backgroundView, final: detailsViewController.backgroundView())
    }
    
}
    

