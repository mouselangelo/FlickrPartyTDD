//
//  Mocks.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

typealias CompletionHandler = (NSData!, NSURLResponse!, NSError!)
    -> Void

typealias Response = (data: NSData?, urlResponse: NSURLResponse?, error: NSError?)


class MockURLSession: NSURLSession {
    
    var mockResponse: Response?
    var completionHandler: CompletionHandler?
    var url: NSURL?
    var dataTask: MockDataTask!
    
    override func dataTaskWithURL(url: NSURL,
                                  completionHandler: (NSData?, NSURLResponse?, NSError?) ->
        Void) -> NSURLSessionDataTask {
        self.url = url
        self.completionHandler = completionHandler
        dataTask = MockDataTask(completionHandler: completionHandler, mockResponse: mockResponse)
        return dataTask
    }
}

class MockDataTask: NSURLSessionDataTask {
    
    let completionHandler: CompletionHandler?
    let mockResponse: Response?
    
    init(completionHandler: CompletionHandler? = nil, mockResponse: Response? = nil) {
        self.completionHandler = completionHandler
        self.mockResponse = mockResponse
    }
    
    var resumeGotCalled = false
    
    override func resume() {
        resumeGotCalled = true
        if let completionHandler = completionHandler, mockResponse = mockResponse {
            completionHandler(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
    }
}