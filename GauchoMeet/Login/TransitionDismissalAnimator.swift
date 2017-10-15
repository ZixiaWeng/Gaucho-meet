//
//  TransitionDismissalAnimator.swift
//  ZappTest
//
//  Created by Sztanyi Szabolcs on 24/09/14.
//  Copyright (c) 2014 ZappDesignTemplates. All rights reserved.
//

import UIKit

class TransitionDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView

        let animationDuration = self .transitionDuration(using: transitionContext)

        let snapshotView = fromViewController.view.resizableSnapshotView(from: fromViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        snapshotView?.center = toViewController.view.center
        containerView.addSubview(snapshotView!)

        fromViewController.view.alpha = 0.0

        let toViewControllerSnapshotView = toViewController.view.resizableSnapshotView(from: toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        containerView.insertSubview(toViewControllerSnapshotView!, belowSubview: snapshotView!)

        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                snapshotView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                snapshotView?.alpha = 0.0
            }, completion: { (finished) -> Void in
                toViewControllerSnapshotView?.removeFromSuperview()
                snapshotView?.removeFromSuperview()
                fromViewController.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
            
    }

}
