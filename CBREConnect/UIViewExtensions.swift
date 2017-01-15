//
//  UIViewExtensions.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/16/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import Foundation
import UIKit

//extends UIView class
extension UIView {
    
    //specify animation function
    func animateLabel(x: CGFloat, y: CGFloat){
        //useSpringWithDamping specifies bouncing level
        UIView.animate(withDuration: 0.7, delay: 0.3, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            self.center = CGPoint(x: x, y: y)
        }, completion: nil)
    }
    
    //specify fade in function
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) { //@escaping indicates the closure escapes the function body
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    //specify fade out function
    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) { //@escaping indicates the closure escapes the function body
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func loadViewFromNib(nibName: String, owner: AnyObject?, forClass: AnyClass) -> UIView {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: forClass))
        let view = nib.instantiate(withOwner: owner, options: nil)[0] as! UIView
        return view
    }
    
}
