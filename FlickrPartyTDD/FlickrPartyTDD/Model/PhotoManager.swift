//
//  PhotoManager.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class PhotoManager {
    var count: Int = 0
    
    private var photos = [Photo]()
    
    func addPhoto(photo: Photo) {
        count += 1
        photos.append(photo)
    }
    
    func photoAtIndex(index: Int) -> Photo? {
        guard (index >= 0 && index < photos.count) else {
            return nil
        }
        
        return photos[index]
    }
    
    func removeAll() {
        count = 0
        photos.removeAll()
    }
    
}