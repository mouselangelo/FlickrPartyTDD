//
//  PhotoLoaderTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class PhotoLoaderTests: XCTestCase {

    var sut: PhotoLoader!

    override func setUp() {
        sut = FlickrPhotoLoader(apiService: MockAPIService(), parser: FlickrResponseParser())
    }

    override func tearDown() {
        sut = nil
    }

    func testPhotoLoader_LoadsPhotos() {
        sut.loadPhotos(1) { (result, error) in
            XCTAssertNotNil(result)
        }
    }

    func testPhotoLoader_WithoutMock_LoadsPhotos() {
        if TestRunnerHelper.skipTestsWithNetworkCalls {
            return
        }
        let sut = FlickrPhotoLoader(apiService: FlickrAPIService(), parser: FlickrResponseParser())
        let expectation = expectationWithDescription("LoadPhotosfromAPI")
        sut.loadPhotos(1) { (result, error) in
            if let result = result {
                print(result)
                expectation.fulfill()
            }
        }
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testPhotoLoader_OnError_HandlesError() {
        let sut = FlickrPhotoLoader(
            apiService: MockAPIServiceWithError(),
            parser: FlickrResponseParser())
        let expectation = expectationWithDescription("PhotoLoader should return error")
        sut.loadPhotos { (result, error) in
            if let _ = error {
                expectation.fulfill()
            }
        }
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    private static let sampleResponse: String = {
        let bundle = NSBundle(forClass: PhotoLoaderTests.self)
        guard let path = bundle.pathForResource(
            "sample_response", ofType: "json") else {
                return ""
        }
        guard let data = NSData(contentsOfFile: path) else { return "" }
        let string = String(data: data, encoding: NSUTF8StringEncoding)
        return string ?? ""
    }()
}

extension PhotoLoaderTests {
    class MockAPIService: FlickrAPIService {
        override func search(tag: String, pageNumber: Int, completion: Handler) {
            completion(result: PhotoLoaderTests.sampleResponse, error: nil)
        }
    }

    class MockAPIServiceWithError: FlickrAPIService {
        override func search(tag: String, pageNumber: Int, completion: Handler) {
            completion(result: nil, error: ServiceError.RequestFailed)
        }
    }
}
