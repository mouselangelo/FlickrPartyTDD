//
//  FlickrAPIService.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class FlickrAPIService {

    typealias Handler = (result: String?, error: ServiceError?) -> Void

    let config = Config()

    lazy var session: NSURLSession = NSURLSession.sharedSession()


    func search(tag: String, pageNumber: Int, completion: Handler) {

        // store query parameters in dictionary
        var params = [String:String]()

        // tag
        params[QueryParams.Tags] = tag
        // page number
        params[QueryParams.PageNumber] = String(pageNumber)

        // default page size
        params[QueryParams.PageSize] = String(config.defaultPageSize)
        // media type
        params[QueryParams.MediaType] = config.defaultMediaType

        guard let url = buildURL(config.searchMethod, params: params)
            else { fatalError("Unable to build URL") }

        sendRequest(url) {  (data, response, error) in

            guard error == nil else {
                print(error?.localizedDescription)
                completion(result: nil, error: ServiceError.RequestFailed)
                return
            }

            guard let response = response as? NSHTTPURLResponse
                else { fatalError("Not HTTP response?")}

            guard response.statusCode == 200 else {
                completion(result: nil, error: ServiceError.RequestFailed)
                return
            }

            guard let data = data else {
                completion(result: nil, error: ServiceError.InvalidResponse)
                return
            }

            guard let result = String(data: data, encoding: NSUTF8StringEncoding)
                where result.characters.count > 0 else {
                completion(result: nil, error: ServiceError.InvalidResponse)
                return
            }
          //  print("Result : \(result)")
            completion(result: result, error: nil)
        }
    }

    private func sendRequest(
        url: NSURL,
        completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let task = session.dataTaskWithURL(
            url, completionHandler: completionHandler)
        task.resume()
    }

    private func buildURL(method: String, params: [String : String]?) -> NSURL? {

        // initialize URLComponents with the base API endoint URL
        guard let urlComponents = NSURLComponents(
            string: config.apiEndpoint)
            else { fatalError("Invalid Endpoint URL") }


        // store the various components in an array
        var queryStringComponents = [String]()

        // add app key and method
        queryStringComponents.append("\(QueryParams.APIKey)=\(config.applicationKey)")

        // method
        queryStringComponents.append("\(QueryParams.Method)=\(method)")

        // JSON Format (default format)
        queryStringComponents.append("\(QueryParams.ResponseFormat)=\(config.defaultFormat)")

        /*
         NOTE : Required parameter to receive RAW Json data
         Refer: https://www.flickr.com/services/api/response.json.html
         If you just want the raw JSON, with no function wrapper, add the parameter
         nojsoncallback with a value of 1 to your request.
         */
        queryStringComponents.append("\(QueryParams.NoJSONCallback)=1")

        // add all other params if present
        if let params = params {
            for (key, value) in params {
                queryStringComponents.append("\(key)=\(value)")
            }
        }

        urlComponents.query = queryStringComponents.joinWithSeparator("&")

        return urlComponents.URL
    }

}


/*
 extension NSURLSession : FlickrURLSession {}
 */
extension FlickrAPIService {
    struct  Config {
        private let applicationKey = "USE_YOUR_OWN_API_KEY_HERE"
        private let apiEndpoint = "https://api.flickr.com/services/rest/"
        private let searchMethod = "flickr.photos.search"
        private let defaultMediaType = "photos"
        private let defaultFormat = "json"
        private let defaultPageSize = 36
    }
}

extension FlickrAPIService {
    struct QueryParams {
        static let APIKey = "api_key"
        static let Method = "method"
        static let PageSize = "per_page"
        static let PageNumber = "page"
        static let Tags = "tags"
        static let MediaType = "media"
        static let ResponseFormat = "format"
        static let NoJSONCallback = "nojsoncallback"
    }
}

enum ServiceError: ErrorType {
    case RequestFailed
    case InvalidResponse
    case InvalidJSON
}
