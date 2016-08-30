//
//  RefreshCollectionViewCell.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 30/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class RefreshCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "RefreshCell"
    
    private var imageView:UIImageView!
    private var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    private func baseInit() {
        self.initIcon()
        self.initLabel()
    }
    
    private func initIcon() {
        imageView = UIImageView(image: UIImage(named: "ic_refresh"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.sizeToFit()
        
        addSubViewCentered(imageView, horizontalOffset: 0, verticalOffset:  20)
        
    }
    
    private func initLabel() {
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Tap to Retry"
        label.textColor = UIColor(white: 0.25, alpha: 1.0)
        label.font = label.font.fontWithSize(13.0)
        
        label.sizeToFit()
        
        addSubViewCentered(label, horizontalOffset: 0.0, verticalOffset:  -20.0 )
        
    }
}
