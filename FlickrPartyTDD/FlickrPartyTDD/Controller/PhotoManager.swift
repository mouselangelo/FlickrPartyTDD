//
//  PhotoManager.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class PhotoManager {
    
    static let DataChangeNotificationName = "PhotoManagerDataChanged"
    static let NetworkCallFailedNotificationName = "PhotoLoaderError.NetworkCallFailed"
    
    
    private var loader: PhotoLoader?
    
    private var photos = [Photo]()
    
    init() {
    }
    
    init(loader: PhotoLoader) {
        self.loader = loader
    }
    
    func loadPhotos() {
        loader?.loadPhotos { (result, error) in
            guard error == nil else {
                self.handleError(error)
                return
            }
            guard let result = result else { return }
            self.addAll(result)
        }
    }
    
    private func handleError(error: PhotoLoaderError?) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            PhotoManager.NetworkCallFailedNotificationName,
            object: self,
            userInfo: nil)
    }
    
    private func dataChanged() {
        NSNotificationCenter.defaultCenter().postNotificationName(
            PhotoManager.DataChangeNotificationName, object: self)
    }
    
    /** Returns the count of Photos*/
    var count: Int {
        return photos.count
    }
    
    /** Adds a single Photo */
    func add(photo: Photo) {
        photos.append(photo)
        dataChanged()
    }
    
    /** Returns the item at a given index or nil*/
    func itemAtIndex(index: Int) -> Photo? {
        guard (index >= 0 && index < photos.count) else {
            return nil
        }
        
        return photos[index]
    }
    
    /** Removes all Photos */
    func removeAll() {
        photos.removeAll()
        dataChanged()
    }
    
    /** Adds all Photos from given array of Photos */
    func addAll(items: [Photo]) {
        photos.appendContentsOf(items)
        dataChanged()
    }
    
}