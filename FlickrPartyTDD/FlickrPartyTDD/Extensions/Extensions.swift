//
//  Extensions.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

extension UIView {
    /** adds a subview and adds the autolayout constraints to pin all edges to the parent (current) view*/
    func addSubViewPinningEdges(target:UIView) {
        self.addSubview(target)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: target, attribute: .Left, multiplier: 1, constant: 0)
        
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: target, attribute: .Right, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: target, attribute: .Top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: target, attribute: .Bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
}