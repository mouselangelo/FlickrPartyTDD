//
//  Extensions.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

extension UIView {
    /** 
     Adds a subview and adds the autolayout constraints to pin all edges to the parent (current) view
     
     - parameter target: Subview to be added to the current view
     */
    func addSubViewPinningEdges(target:UIView) {
        self.addSubview(target)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: target, attribute: .Left, multiplier: 1, constant: 0)
        
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: target, attribute: .Right, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: target, attribute: .Top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: target, attribute: .Bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    
    /** 
     Adds a subview and adds the autolayout constraints to center this view to the parent (current) view
     
       - parameters:
          - target: Subview to be added to the current view
          - horizontalOffset: Horizontal offset
          - verticalOffset: Vertical offset
     */
    func addSubViewCentered(target:UIView, horizontalOffset: CGFloat = 0, verticalOffset: CGFloat = 0) {
        self.addSubview(target)
        
        let horizontalCenter = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: target, attribute: .CenterX, multiplier: 1, constant: horizontalOffset)
        
        let verticalCenter = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: target, attribute: .CenterY, multiplier: 1, constant: verticalOffset)
        
        self.addConstraints([horizontalCenter, verticalCenter])
    }
}

extension UIViewController {
    /**
     Displays a standard `UIAlert` to indicate that network connectivity is lost.
     Two `UIAlertActions` - *Cancel* and *Retry* are also displayed. The `retryCallback` closure will be called (if provided) when user chooses *Retry*
     - parameter retryCallback: Optional closure to be called if user taps on *Retry*
    */
    func showNoANetworAlert(retryCallback: (() -> Void)?) -> UIAlertController {
        let alertVC = UIAlertController(
            title: "No Network",
            message: "Looks like you are not connected to the Internet. Please reconnect and try again!",
            preferredStyle: .Alert)
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertVC.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { (action) in
            guard let retryCallback = retryCallback else { return }
            retryCallback()
        }))
        self.presentViewController(alertVC, animated: true, completion: nil)
        return alertVC
    }
}

