//
//  FlickrAPIServiceTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class FlickrAPIServiceTests: XCTestCase {
    
    var sut: FlickrAPIService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        sut = FlickrAPIService()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    func testSearch_MakesRequestFromTag() {
        let completion = { (json:String?, error: ErrorType?) in }
        sut.search("party", pageNumber: 1, completion: completion)
        
        XCTAssertNotNil(mockURLSession.completionHandler,
                        "calling search must sets the completionHandler on mock")
        
        guard let url = mockURLSession.url else { XCTFail("URL must be set on mock"); return }
        
        let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        
        XCTAssertEqual(urlComponents?.host, "api.flickr.com")
        
        XCTAssertEqual(urlComponents?.path, "/services/rest/")
        
        // check if tags and page are present in the query params
        
        guard let params = urlComponents?.queryItems else { XCTFail("URL has no query parameters"); return }
        
        var tagQueryItem: NSURLQueryItem? = nil
        var pageNumberQueryItem: NSURLQueryItem? = nil
        
        for param in params {
            if param.name == "tags" {
                tagQueryItem = param
            } else if param.name == "page" {
                pageNumberQueryItem = param
            }
        }
        
        XCTAssertNotNil(tagQueryItem, "tags query parameter should be present")
        
        XCTAssertNotNil(pageNumberQueryItem, "page query parameter should be present")
        
        
        XCTAssertEqual(tagQueryItem?.value, "party", "Query param should match search() method argument")
        
        XCTAssertEqual(pageNumberQueryItem?.value, "1", "Query param should match search() method argument")
    }
    
    func testSearch_CallsResumeOfDataTask() {
        let completion = { (json:String?, error: ErrorType?) in }
        sut.search("party", pageNumber: 1, completion: completion)
        
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled, "resume() should have been called ")
    }
    
    func testSearch_OnCompletionReturnsExpectedData() {
        
        let testDict = ["result" : "success"]
        let testData = try! NSJSONSerialization.dataWithJSONObject(testDict, options: [])
        
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "http://example.com")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        
        mockURLSession.mockResponse = (testData, urlResponse, nil)
        
        sut.search("party", pageNumber: 1) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            
            guard let data = result?.dataUsingEncoding(NSUTF8StringEncoding) else { XCTFail(); return }
            
            if let jsonObj = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0)) as? [String:AnyObject] {
                XCTAssertEqual(jsonObj["result"] as? String, "success")
            } else {
                XCTFail()
            }
        }
        
    }
    
    func testSearch_FailedHttpResponseRetursRequestFailedError() {
        
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "http://example.com")!, statusCode: 404, HTTPVersion: nil, headerFields: nil)
        
        mockURLSession.mockResponse = (nil, urlResponse, nil)
        
        sut.search("party", pageNumber: 1) { (result, error) in
            XCTAssertNotNil(error, "API service must return error when HTTP error occurs")
            XCTAssertEqual(error, ServiceError.RequestFailed, "Error must be RequestFailed")
        }
    }
    
    func testSearch_NilDataReturnsInvalidResponseError() {
        
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "http://example.com")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        
        mockURLSession.mockResponse = (nil, urlResponse, nil)
        
        sut.search("party", pageNumber: 1) { (result, error) in
            XCTAssertNotNil(error, "API service must return error when invalid data recieved")
            XCTAssertEqual(error, ServiceError.InvalidResponse, "Error must be InvalidResponse")
        }
    }
    
    func testSearch_InvalidDataReturnsInvalidResponse() {
        
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "http://example.com")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        
        
        mockURLSession.mockResponse = (NSData(), urlResponse, nil)
        
        sut.search("party", pageNumber: 1) { (result, error) in
            XCTAssertNotNil(error, "API service must return error when invalid data recieved")
            XCTAssertEqual(error, ServiceError.InvalidResponse, "Error must be InvalidResponse")
        }
    }
    
    func testSearch_ResposeWithErrorReturnsRequestFailed() {
        
        mockURLSession.mockResponse = (nil, nil, NSError(domain: "test", code: 0, userInfo: nil))
        
        sut.search("party", pageNumber: 1) { (result, error) in
            XCTAssertNotNil(error, "API service must return error when HTTP error occurs")
            XCTAssertEqual(error, ServiceError.RequestFailed, "Error must be RequestFailed")
        }
    }
}
