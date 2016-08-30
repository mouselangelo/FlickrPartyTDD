//
//  FlickrResponseParserTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class FlickrResponseParserTests: XCTestCase {

    var sut: FlickrResponseParser!

    override func setUp() {
        sut = FlickrResponseParser()
    }

    override func tearDown() {
        sut = nil
    }

    func testParser_WhenGivenInvalidJSON_ReturnsError() {
        sut.parse("This is not json") { (result, totalCount, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error, ServiceError.InvalidJSON, "Should be InvalidJSON error")
        }
    }

    func testParser_WhenGivenValidJSON_ReturnsPhotosArray() {
        sut.parse(FlickrResponseParserTests.sampleResponse) { (result, totalCount, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.count, 36, "Sample response has 36 photos")
        }
    }

    func testParser_WhenGivenValidJSON_ParsesPhotosCorrectly() {
        sut.parse(FlickrResponseParserTests.sampleResponse) { (result, totalCount, error) in

            guard let result = result else { XCTFail(); return }

            guard let firstPhoto = result.first else { XCTFail(); return }

            XCTAssertEqual(firstPhoto.title,
                           "Summer Reading Program 2016 - Winners of the Gold Medal Pool Party")
        }
    }

    func testParser_WhenGivenValidJSON_ParsesPhotoURLCorrectly() {
        let expectedURL = "https://farm9.staticflickr.com/8531/29188984311_e01baf9c1d.jpg"
        sut.parse(FlickrResponseParserTests.sampleResponse) { (result, totalCount, error) in

            guard let result = result else { XCTFail(); return }

            guard let firstPhoto = result.first else { XCTFail(); return }

            XCTAssertEqual(firstPhoto.url.absoluteString, expectedURL)
        }
    }

    func testParser_WhenGivenValidJSONResponse_ReturnsInvalidJSONError() {

        let obj = ["greeting" : "Hello World!"]

        guard let jsonObj = try? NSJSONSerialization.dataWithJSONObject(
            obj, options: []) else {
                XCTFail()
                return
        }

        let jsonString = String(data: jsonObj, encoding: NSUTF8StringEncoding)!

        sut.parse(jsonString) { (result, totalCount, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error, ServiceError.InvalidJSON, "Should be InvalidJSON error")
        }
    }

    func testParser_WhenGivenValidJSONResponseWithNoPhotosArray_ReturnsInvalidJSON() {

        let obj = ["photos" : ["photo" : "test"]]

        guard let jsonObj = try? NSJSONSerialization.dataWithJSONObject(
            obj, options: []) else {
                XCTFail()
                return
        }

        guard let jsonString = String(data: jsonObj,
                                      encoding: NSUTF8StringEncoding) else {
                                        XCTFail()
                                        return
        }

        sut.parse(jsonString) { (result, totalCount, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error, ServiceError.InvalidJSON, "Should be InvalidJSON error")
        }
    }

    func testParser_WhenGivenValidJSONResponseWithNoPhotos_ReturnsZeroPhotos() {

        let obj = ["photos" : ["photo" : ["A", "B", "C", "D"], "total" : "100"]]

        guard let jsonObj = try? NSJSONSerialization.dataWithJSONObject(
            obj, options: []) else {
                XCTFail()
                return
        }

        let jsonString = String(data: jsonObj, encoding: NSUTF8StringEncoding)!

        sut.parse(jsonString) { (result, totalCount, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(totalCount, 100)
            XCTAssertEqual(result?.count, 0)
        }
    }

    private static let sampleResponse: String = {
        let bundle = NSBundle(forClass: FlickrResponseParserTests.self)
        guard let path = bundle.pathForResource(
            "sample_response", ofType: "json") else {
                return ""
        }
        guard let data = NSData(contentsOfFile: path) else { return "" }
        let string = String(data: data, encoding: NSUTF8StringEncoding)
        return string ?? ""
    }()
}
