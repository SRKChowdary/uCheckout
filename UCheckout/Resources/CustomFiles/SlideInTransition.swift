//
//  SlideInTransition.swift
//  SlideInTransition
//
//  Created by Gary Tokman on 1/13/19.
//  Copyright © 2019 Gary Tokman. All rights reserved.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting = false
    let dimmingView = UIView()
    var vc : UIViewController?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        vc = toViewController
        let containerView = transitionContext.containerView

        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height

        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)

            // Init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
            let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
            tap.numberOfTapsRequired = 1
            dimmingView.addGestureRecognizer(tap)
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeRight.direction = .left
            dimmingView.addGestureRecognizer(swipeRight)
        }

        // Move on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }


        // Move back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }

        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
    @objc func singleTapped() {
        vc?.dismiss(animated: true, completion: nil)
        
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer)  {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left:
             vc?.dismiss(animated: true, completion: nil)
            
        default:
            break
        }
        
    }

}
