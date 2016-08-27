//
//  FlickrResponseParser.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class FlickrResponseParser {
    typealias ParserHandler = (result: [Photo]?, totalCount: Int, error: ServiceError?) -> Void
    
    func parse(json:String, handler: ParserHandler) {
        
        guard let data = json.dataUsingEncoding(NSUTF8StringEncoding) else {
            handler(result: nil, totalCount: -1, error: ServiceError.InvalidJSON)
            return
        }
        
        guard let jsonResponse = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) else { handler(result: nil, totalCount: -1, error: ServiceError.InvalidJSON); return }
        
        guard let result = jsonResponse["photos"] as? [String:AnyObject] else { handler(result: nil, totalCount: -1, error: ServiceError.InvalidJSON); return }
        
        var resultTotalCount = 0
        
        if let total = result["total"] as? String {
            resultTotalCount = Int(total) ?? 0
            print("Total Results \(resultTotalCount)")
        }
        
        guard let photoArray = result["photo"] as? [AnyObject] else { handler(result: nil, totalCount: -1, error: ServiceError.InvalidJSON); return }
        
        var photos = [Photo]()
        
        for photoDict in photoArray {
            guard let photoDict = photoDict as? [String:AnyObject] else { continue }
            if let photo = parsePhoto(photoDict) {
                photos.append(photo)
            }
        }
        
        handler(result: photos, totalCount: resultTotalCount, error: nil)
    }
}

private func parsePhoto(photoDict:AnyObject) -> Photo? {
    let title = photoDict["title"] as? String
    
    guard let farmId = photoDict["farm"] as? Int,  serverId = photoDict["server"] as? String, photoId = photoDict["id"] as? String,  secret = photoDict["secret"] as? String else {return nil}
    
    let photoURLString = "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secret).jpg"
    
    let thumbnailURLString = "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secret)_q.jpg"
    
    if let photoURL = NSURL(string: photoURLString), thumbnailURL = NSURL(string: thumbnailURLString) {
        let photo = PhotoItem(url: photoURL, thumbnailURL: thumbnailURL, title: title)
        return photo
    }
    return nil
}