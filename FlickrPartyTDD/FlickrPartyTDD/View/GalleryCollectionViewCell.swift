//
//  GalleryCollectionViewCell.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    var photo: Photo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    func baseInit() {
        backgroundColor = UIColor.blueColor()
    }
    
    
    func configCell(withItem item: Photo) {
        photo = item
    }
    
}
