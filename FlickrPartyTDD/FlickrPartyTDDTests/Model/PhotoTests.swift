//
//  PhotoTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

/**
Tests for Photo (Model) that's used to store photo instances
 */
class PhotoTests: XCTestCase {
    
    var sut:Photo!
    var testURL = NSURL(string: "http://example.com")!
    
    override func setUp() {
        sut = PhotoItem(url: testURL,
                    thumbnailURL: testURL,
                    title: "Test Title")
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testPhoto_ShouldHaveURL() {
        XCTAssertNotNil(sut.url,
                        "URL is set")
        XCTAssertEqual(sut.url,
                       testURL, "Correct URL should be set")
    }
    
    func testPhoto_CanHaveTitle() {
        XCTAssertNotNil(sut.title,
                        "Title is set")
        XCTAssertEqual(sut.title,
                       "Test Title", "Correct title should be set")
    }
    
    func testTitleIsOptional() {
        let photoWithoutTitle = PhotoItem(url: testURL,
                                      thumbnailURL: testURL)
        XCTAssertNil(photoWithoutTitle.title, "Title can be nil")
    }
    
    func testPhoto_MustHaveThumbnailURL() {
        XCTAssertEqual(sut.thumbnailURL, testURL,
                       "Thumbanil URL should be set corrtectly")
    }
    
}
