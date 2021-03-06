//
//  PhotoLoader.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

struct PhotoResponse {
    var photos: [Photo]
    var totalCount: Int
}

protocol PhotoLoader {
    func loadPhotos(
        page: Int,
        completion: (result: PhotoResponse?, error: PhotoLoaderError?) -> Void)
}

enum PhotoLoaderError: ErrorType {
    case NetworkCallFailed
}
