//
//  DataProvider.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit
/**
 Instances of conforming types can act as delegate and data source
 for UICollectionViews and can manage Photos */
protocol CollectionViewDataProvider: UICollectionViewDataSource {

    /**
     Ask the CollectionViewDataProvider to register the various UICollectionViewCell
     type identifiers that it is interested in. Conforming types will thus be able to
     deque these cells when required.
     */
    func registerCellIdentifiers(collectionView: UICollectionView)

}

/** Instances of conforming types can use PhotoManager to manage Photos */
protocol PhotoManageable {
    /**
     Set / Get PhotoManager instances. Intended to be used to inject the PhotoManager
     dependency on conforming types
     */
    var photoManager: PhotoManager? { get set }
}

/**
 Instances of conforming types can use PhotoManager to manage Photos and act as Delegate
 and Data source for UICollectionView */
protocol PhotoDataProvider: CollectionViewDataProvider, PhotoManageable {
    var photoCount: Int { get }
}
