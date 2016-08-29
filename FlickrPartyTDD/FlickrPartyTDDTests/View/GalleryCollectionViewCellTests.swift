//
//  GalleryCollectionViewCellTets.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class GalleryCollectionViewCellTests: XCTestCase {
    
    var sut: GalleryCollectionViewCell!
    var dataSource: FakeDataSource!
    var collectionView: UICollectionView!
    var viewController: GalleryViewController!
    
    override func setUp() {
        viewController = GalleryViewController()
        _ = viewController.view
        collectionView = viewController.collectionView
        
        dataSource = FakeDataSource()
        collectionView.dataSource =  dataSource
        collectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCell")
        
        sut = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: NSIndexPath(forItem: 0, inSection: 0)) as! GalleryCollectionViewCell
    }
    
    override func tearDown() {
        sut = nil
        dataSource = nil
        collectionView = nil
        viewController = nil
    }
    
    func testGalleryCell_IsNotNil() {
        XCTAssertNotNil(sut)
    }
    
    func testGalleryCell_HasImageView() {
        XCTAssertNotNil(sut.imageView, "ImageView should have been initialized")
    }
    
    func testCellImageView_AfterConfigCell_HasImage() {
        if TestRunnerHelper.skipTestsWithNetworkCalls {
            return
        }
        let photo = createPhotoWithSampleItem()
        sut.configCell(withItem: photo)
        let exists = NSPredicate(format: "image != nil")
        
        expectationForPredicate(exists,
                                evaluatedWithObject: sut.imageView!, handler: nil)
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
}

extension GalleryCollectionViewCellTests {
    class FakeDataSource: NSObject, UICollectionViewDataSource {
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            return GalleryCollectionViewCell()
        }
    }
    
    func createPhotoWithSampleItem() -> Photo {
        let thumbnail = NSURL(string: "https://farm9.staticflickr.com/8138/29236520941_1d41653aed_q.jpg")!
        let url = NSURL(string: "https://farm9.staticflickr.com/8138/29236520941_1d41653aed.jpg")!
        let title = "Sample Photo"
        
        let photo = PhotoItem(
            url: url,
            thumbnailURL: thumbnail,
            title: title)
        
        return photo
    }
}
