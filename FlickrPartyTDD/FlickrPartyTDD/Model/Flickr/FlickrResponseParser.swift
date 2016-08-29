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
        
        guard let data = json.dataUsingEncoding(NSUTF8StringEncoding) else { invalidJSON(handler); return }
        guard let jsonResponse = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) else { invalidJSON(handler); return }
        
        guard let result = jsonResponse[JSONKeys.photos] as? [String:AnyObject] else { invalidJSON(handler); return }
        
        var resultTotalCount = 0
        
        if let total = result[JSONKeys.total] as? String {
            resultTotalCount = Int(total) ?? 0
            print("Total Results \(resultTotalCount)")
        }
        
        guard let photoArray = result[JSONKeys.photo] as? [AnyObject] else { invalidJSON(handler); return }
        var photos = [Photo]()
        
        for photoDict in photoArray {
            guard let photoDict = photoDict as? [String:AnyObject] else { continue }
            if let photo = parsePhoto(photoDict) {
                photos.append(photo)
            }
        }
        
        handler(result: photos, totalCount: resultTotalCount, error: nil)
    }
    
    private func invalidJSON(handler: ParserHandler) {
        handler(result: nil, totalCount: -1, error: ServiceError.InvalidJSON);
    }
    
    private func parsePhoto(photoDict:AnyObject) -> Photo? {
        let title = photoDict[JSONKeys.photoTitle] as? String
        
        guard let farmId = photoDict[JSONKeys.photoFarmId] as? Int,  serverId = photoDict[JSONKeys.photoServer] as? String, photoId = photoDict[JSONKeys.photoId] as? String,  secret = photoDict[JSONKeys.photoSecret] as? String else {return nil}
        
        let photoURLString = "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secret).jpg"
        
        let thumbnailURLString = "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secret)_q.jpg"
        
        if let photoURL = NSURL(string: photoURLString), thumbnailURL = NSURL(string: thumbnailURLString) {
            let photo = PhotoItem(url: photoURL, thumbnailURL: thumbnailURL, title: title)
            return photo
        }
        return nil
    }
}

struct JSONKeys {
    static let photos = "photos"
    static let total = "total"
    static let photo = "photo"
    static let photoTitle = "title"
    static let photoFarmId = "farm"
    static let photoServer = "server"
    static let photoId = "id"
    static let photoSecret = "secret"
}