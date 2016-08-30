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

    override func tearDown() {
        sut = nil
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

        let anotherPhoto =
            PhotoItem(url: NSURL(string: "http://example2.com")!,
                      thumbnailURL: NSURL(string: "http://example2.com")!,
                      title: "Another photo")

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

    func testAddingAPhoto_FiresDataChangedNotification() {
        let itemToAdd = generateItems(1).first!
        expectationForNotification(PhotoManager.DataChangeNotificationName,
                                   object: sut) { (notification) -> Bool in
            return true
        }
        sut.add(itemToAdd)
        waitForExpectationsWithTimeout(1, handler: nil)
        XCTAssertEqual(sut.count, 1)
    }

    func testAddingPhotos_FiresDataChangedNotification() {
        let itemsToAdd = generateItems(10)
       expectationForNotification(PhotoManager.DataChangeNotificationName,
                                  object: sut) { (notification) -> Bool in
            return true
        }
        sut.addAll(itemsToAdd)
        waitForExpectationsWithTimeout(1, handler: nil)
        XCTAssertEqual(sut.count, itemsToAdd.count)
    }

    func testRemovingPhotos_FiresDataChangedNotification() {
        let itemsToAdd = generateItems(10)
        sut.addAll(itemsToAdd)
        XCTAssertEqual(sut.count, itemsToAdd.count)
        expectationForNotification(PhotoManager.DataChangeNotificationName,
                                   object: sut) { (notification) -> Bool in
            return true
        }
        sut.removeAll()
        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testPhotoManager_OnSuccessfullyLoadingPhotos_FiresNotification() {
        let mockLoader = MockPhotoLoader()
        mockLoader.photosToReturn = generateItems(5)
        let sut = PhotoManager(loader: mockLoader)
        expectationForNotification(
            PhotoManager.DataChangeNotificationName,
            object: sut, handler: nil)
        sut.loadPhotos()
        waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testPhotoManager_OnErrorLoadingPhotos_FiresNotification() {
        let mockLoader = MockPhotoLoader()

        let sut = PhotoManager(loader: mockLoader)

        expectationForNotification(
            PhotoManager.NetworkCallFailedNotificationName,
            object: sut, handler: nil)
        sut.loadPhotos()
        waitForExpectationsWithTimeout(10, handler: nil)
    }




    private func generateItems(count: Int) -> [Photo] {
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

extension PhotoManagerTests {
    class MockPhotoLoader: PhotoLoader {

        var photosToReturn: [Photo]?

        func loadPhotos(page: Int,
                        completion: (result: PhotoResponse?, error: PhotoLoaderError?) -> Void) {
            guard let photos = photosToReturn else {
                completion(result: nil, error: PhotoLoaderError.NetworkCallFailed)
                return
            }

            let response = PhotoResponse(photos: photos, totalCount: 100)
            completion(result: response, error: nil)
        }
    }
}
