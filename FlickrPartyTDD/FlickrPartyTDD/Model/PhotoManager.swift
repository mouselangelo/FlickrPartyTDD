//
//  PhotoManager.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class PhotoManager {
    
    var count: Int {
        return photos.count
    }
    
    private var photos = [Photo]()
    
    func add(photo: Photo) {
        photos.append(photo)
    }
    
    func itemAtIndex(index: Int) -> Photo? {
        guard (index >= 0 && index < photos.count) else {
            return nil
        }
        
        return photos[index]
    }
    
    func removeAll() {
        photos.removeAll()
    }
    
    func addAll(items: [Photo]) {
        photos.appendContentsOf(items)
    }
    
}