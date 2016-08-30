//
//  LoadMoreCollectionViewCell.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 30/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class LoadMoreCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "LoadMoreCell"

    var activityIndicator: UIActivityIndicatorView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }

    private func baseInit() {

        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        addSubViewCentered(activityIndicator)

        activityIndicator.startAnimating()

    }
}
