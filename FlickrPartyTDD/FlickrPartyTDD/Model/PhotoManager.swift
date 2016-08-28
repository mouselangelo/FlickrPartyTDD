//
//  PhotoManager.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class PhotoManager {
    
    private var photos = [Photo]()

    /** Returns the count of Photos*/
    var count: Int {
        return photos.count
    }
    
    /** Adds a single Photo */
    func add(photo: Photo) {
        photos.append(photo)
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
    }
    
    /** Adds all Photos from given array of Photos */
    func addAll(items: [Photo]) {
        photos.appendContentsOf(items)
    }
    
}