//
//  Photo.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

/**
 Types must conform to this protocol, to be displayable in the gallery
 */
protocol Photo {
    
    /** URL to the full image */
    var url: NSURL { get }
    
    /** URL to the thumbnail image */
    var thumbnailURL: NSURL { get }
    
    /** Optional title */
    var title: String? { get }
    
}