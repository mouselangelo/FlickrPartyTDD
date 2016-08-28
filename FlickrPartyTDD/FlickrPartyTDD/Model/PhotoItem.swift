//
//  PhotoItem.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

/**
 Implementation of a Photo
 */
class PhotoItem: Photo {
    let url: NSURL
    let thumbnailURL: NSURL
    let title: String?
    
    
    init(url: NSURL, thumbnailURL: NSURL, title: String? = nil) {
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.title = title
    }
}