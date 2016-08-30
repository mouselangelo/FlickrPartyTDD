//
//  GalleryCollectionViewCell.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit
import Kingfisher

class GalleryCollectionViewCell: UICollectionViewCell {

    var imageView: UIImageView?

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
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        // initialize the imageView
        imageView = UIImageView()

        // using autolayout
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        // imageview's image should display within bounds and  scaled to fill
        imageView?.clipsToBounds = true
        imageView?.contentMode = UIViewContentMode.ScaleAspectFill

        // add it to cell pinning edges
        addSubViewPinningEdges(imageView!)
    }


    func configCell(withItem item: Photo) {
        photo = item
        imageView?.kf_setImageWithURL(item.thumbnailURL)
    }

}
