//
//  GalleryDataProvider.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class GalleryDataProvider: NSObject, PhotoDataProvider {

    // identified for the reusable cell
    private let identifier:String = "GalleryCell"

    var photoManager: PhotoManager?
    
    func registerCellIdentifiers(collectionView: UICollectionView) {
        // register the identifier(s) we are interested in
        collectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoManager?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // deque the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! GalleryCollectionViewCell
        // get the item and configure cell
        if let item = photoManager?.itemAtIndex(indexPath.item)  {
            cell.configCell(withItem: item)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("PhotoSelectedNotification", object: self, userInfo: ["index" : indexPath.item])
    }
    
    // optional as defaults to 1 anyway
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}