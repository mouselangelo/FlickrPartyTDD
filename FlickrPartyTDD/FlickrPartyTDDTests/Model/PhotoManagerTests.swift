//
//  PhotoManagerTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class PhotoManagerTests: XCTestCase {
    
    var sut: PhotoManager!

    lazy var testPhoto: Photo = {
        let testURL = NSURL(string: "http://example.com")!
       return PhotoItem(url: testURL, thumbnailURL: testURL, title: "Test")
    }()
    
    override func setUp() {
        sut = PhotoManager()
    }
    
    func testPhotoManager_ReturnsCountOfPhotos() {
        XCTAssertEqual(sut.count, 0, "Initial count must be 0")
    }
    
    func testAddingPhotos_IncreasesCount() {
        sut.add(testPhoto)
        XCTAssertEqual(sut.count, 1, "Count should be same as number of photos added")
    }
    
    func testGetitemAtIndex_ShouldReturnTheCorrectPhoto() {
        sut.add(testPhoto)
        let firstPhoto = sut.itemAtIndex(0)
        
        XCTAssertEqual(firstPhoto?.url, testPhoto.url,
                       "Should be the photo we just added")
    }
    
    func testGetitemAtIndex_ForDifferentIndices_ShouldReturnTheCorrectPhoto() {
        sut.add(testPhoto)
        
        let anotherPhoto = PhotoItem(url: NSURL(string: "http://example2.com")!, thumbnailURL: NSURL(string: "http://example2.com")!, title: "Another photo")
        
        sut.add(anotherPhoto)
        
        let firstPhoto = sut.itemAtIndex(0)
        let secondPhoto = sut.itemAtIndex(1)
        
        XCTAssertEqual(firstPhoto?.url, testPhoto.url,
                       "Should be the first photo")
        
        XCTAssertEqual(secondPhoto?.url, anotherPhoto.url,
                       "Should be the second photo")
    }
    
    func testRemoveAll_SetsCountToZero() {
        sut.add(testPhoto)
        XCTAssertEqual(sut.count, 1, "Count should be same as number of photos added")
        sut.removeAll()
        XCTAssertEqual(sut.count, 0, "Count should be 0 after remove all")
    }
    
    func testRemoveAll_ShouldRemoveAllItems() {
        sut.add(testPhoto)
        XCTAssertEqual(sut.count, 1, "Count should be same as number of photos added")
        sut.removeAll()
        let noItem = sut.itemAtIndex(0)
        XCTAssertNil(noItem, "There should be no items after removeAll")
    }
    
    func testAddAll_ShouldAddAllItems() {
        let itemsToAdd = generateItems(10)
        sut.addAll(itemsToAdd)
        XCTAssertEqual(sut.count, itemsToAdd.count)
    }
    
    private func generateItems(count:Int) -> [Photo] {
        var photos = [Photo]()
        for i in 1...count {
            let url = NSURL(string: "http://example\(i).com")!
            let item = PhotoItem(url: url, thumbnailURL: url,
                                 title: "Title \(i)")
            photos.append(item)
        }
        return photos
    }
    
}
