//
//  PhotoLoader.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

protocol PhotoLoader {
    func loadPhotos(completion: (result:[Photo]?, error:PhotoLoaderError?) -> Void)
}

enum PhotoLoaderError: ErrorType {
    case NetworkCallFailed
}