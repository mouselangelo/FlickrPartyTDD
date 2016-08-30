//
//  GalleryDataProvider.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class GalleryDataProvider: NSObject, PhotoDataProvider, ReachabilityListener {
    
    // identified for the reusable cell
    private let identifier:String = "GalleryCell"
    
    var photoManager: PhotoManager?
    private weak var collectionView: UICollectionView?
    
    private var isNetworkReachable = true
    
    var photoCount: Int {
        return photoManager?.count ?? 0
    }
    
    override init() {
        super.init()
        registerForNotifications()
    }
    
    init(photoManager: PhotoManager) {
        self.photoManager = photoManager
        super.init()
        registerForNotifications()
    }
    
    func onReachabilityChanged(notification: NSNotification) {
        
        print("DataProvider reachability changed...")
        
        guard let reachability = notification.object as? ReachabilityManager else { return }
        isNetworkReachable = reachability.currentState == .Reachable
        
        if isNetworkReachable {
            photoManager?.resume()
        }
        
        guard let photoManager = photoManager where photoManager.hasMore else { return }

        if let indexPaths = collectionView?.indexPathsForVisibleItems() {
            collectionView?.reloadItemsAtIndexPaths(indexPaths)            
        }
    }
    
    private func registerForNotifications() {
        
        // Data changed notification
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(dataChanged),
            name: PhotoManager.DataChangeNotificationName,
            object: photoManager)
        
        // API Error notification
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(apiCallFailed),
            name: PhotoManager.NetworkCallFailedNotificationName,
            object: photoManager)
        
        // Reachability Notifications
        let reachability = DefaultReachabilityManager.sharedInstance
        isNetworkReachable = reachability.currentState == .Reachable
        reachability.startListeningForNetworkNotifications(self)
    }
    
    deinit {
        // Remove notification observers
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func dataChanged(notification: NSNotification) {
        print("Data changed notification received...")
        self.collectionView?.reloadData()
    }
    
    func apiCallFailed(notification: NSNotification) {
        print("API call failed notification received...")

        isNetworkReachable = false
        
        guard let collectionView = collectionView else { return }
        
        collectionView.reloadItemsAtIndexPaths(collectionView.indexPathsForVisibleItems())
    }
    
    func registerCellIdentifiers(collectionView: UICollectionView) {
        // register the identifier(s) we are interested in
        collectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        
        collectionView.registerClass(LoadMoreCollectionViewCell.self, forCellWithReuseIdentifier: LoadMoreCollectionViewCell.reuseIdentifier)
        
        collectionView.registerClass(RefreshCollectionViewCell.self, forCellWithReuseIdentifier: RefreshCollectionViewCell.reuseIdentifier)
        
        self.collectionView = collectionView
        photoManager?.loadPhotos()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photoManager = photoManager else {
            return 0
        }
        return photoManager.count + (photoManager.hasMore ? 1 : 0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.item == photoCount - 12 {
            if isNetworkReachable {
                photoManager?.loadMore()                
            }
        }
        
        guard indexPath.item < photoCount else {
            
            if isNetworkReachable {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LoadMoreCollectionViewCell.reuseIdentifier, forIndexPath: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(RefreshCollectionViewCell.reuseIdentifier, forIndexPath: indexPath)
                return cell
                
            }
        }
        
        // deque the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! GalleryCollectionViewCell
        // get the item and configure cell
        if let item = photoManager?.itemAtIndex(indexPath.item)  {
            cell.configCell(withItem: item)
        }
        return cell
    }
    
    // optional as defaults to 1 anyway
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}