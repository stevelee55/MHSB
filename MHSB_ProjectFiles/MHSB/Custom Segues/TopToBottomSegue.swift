//
//  TopToBottomSegue.swift
//  MHSB
//
//  Created by Steve Lee on 11/22/17.
//  Copyright © 2017 Steve Lee. All rights reserved.
//

import UIKit

class TopToBottomSegue: UIStoryboardSegue {
    
    override func perform() {
        topToBottom()
    }
    
    func topToBottom() {
        let toVC = self.destination
        let fromVC = self.source
        
        let containerView = fromVC.view.superview
        let originalCenter = fromVC.view.center
        
        // set up from 2D transforms that we'll use in the animation
        let offScreenTop = CGAffineTransform(translationX: 0, y: -(containerView?.frame.height)!)
        //let offScreenBottom = CGAffineTransform(translationX: 0, y: -(containerView?.frame.height)!)
        
        
        // start the toView to the right of the screen
        toVC.view.transform = offScreenTop
        toVC.view.center = originalCenter
        
        // add the both views to our view controller
        containerView?.addSubview(toVC.view)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            toVC.view.transform = CGAffineTransform.identity
        }, completion: { finished in
            fromVC.present(toVC, animated: false, completion: nil)
            
        })
    }
}

class UnwindTopToBottomSegue: UIStoryboardSegue {
    override func perform() {
        topToBottom()
    }
    
    func topToBottom() {
        let toVC = self.destination
        let fromVC = self.source
        
        fromVC.view.superview?.insertSubview(toVC.view, at: 0)
        
        let containerView = fromVC.view.superview
   
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            fromVC.view.transform = CGAffineTransform(translationX: 0, y: -(containerView?.frame.height)!)
        }, completion: { finished in
            fromVC.dismiss(animated: false, completion: nil)
            
        })
    }
}

