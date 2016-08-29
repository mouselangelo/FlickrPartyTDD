//
//  GalleryDataProviderTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class GalleryDataProviderTests: XCTestCase {
    var sut: PhotoDataProvider!
    var galleryViewController: GalleryViewController!
    var collectionView: UICollectionView!
    
    override func setUp() {
        sut = GalleryDataProvider()
        sut.photoManager = PhotoManager()
        galleryViewController = GalleryViewController()
        galleryViewController.dataProvider = sut
        _ = galleryViewController.view
        collectionView = galleryViewController.collectionView
        collectionView.dataSource = sut
        collectionView.delegate = sut
        sut.registerCellIdentifiers(collectionView)
    }
    
    func testNumberOfSections_IsOne() {
        let sections = collectionView.numberOfSections()
        XCTAssertEqual(sections, 1, "Collection view has 1 section")
    }
    
    func testNumberOfItemsInSectionOne_IsCountOfPhotos() {
        let photos = generateItems(5)
        sut.photoManager?.addAll(photos)
        XCTAssertEqual(collectionView.numberOfItemsInSection(0), 5, "Should contain same items as added (5) ")
        
        sut.photoManager?.add(createPhoto(withId: 6))
        collectionView.reloadData()
        XCTAssertEqual(collectionView.numberOfItemsInSection(0), 6, "Should contain same items as added (6) ")
    }

    func testCellForItem_ReturnsGalleryCollectionViewCell() {
        
        let collectionView = MockCollectionView(frame: CGRectMake(0, 0, 320, 480), collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.dataSource = sut
        
        collectionView.registerClass(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCell")
        
        
        let photo = createPhoto(withId: 1)
        
        sut.photoManager?.add(photo)
        collectionView.reloadData()
        
        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
        
        XCTAssertNotNil(cell, "Cell should have been created")
        XCTAssertTrue(cell is GalleryCollectionViewCell, "Cell should be of type GalleryCollectionViewCell")
    }
    
    func testCellGetsDequed() {
        let photo = createPhoto(withId: 1)
        sut.photoManager!.add(photo)
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = MockCollectionView(frame: CGRectMake(0, 0, 320, 480), collectionViewLayout: layout)
        
        collectionView.dataSource = sut
        collectionView.delegate = sut
        sut.registerCellIdentifiers(collectionView)
        
        
        XCTAssertFalse(collectionView.cellGotDequeed, "Cell has not been dequed yet")
        
        _ = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
        
        XCTAssertTrue(collectionView.cellGotDequeed, "Cell must get dequed")
    }
    
    func testConfigCellGetsCalled() {
        let mockDataProvider = MockDataProvider()
        mockDataProvider.photoManager = PhotoManager()
        let photo = createPhoto(withId: 1)
        mockDataProvider.photoManager!.add(photo)
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = MockCollectionView(frame: CGRectMake(0, 0, 320, 480), collectionViewLayout: layout)
        
        collectionView.dataSource = mockDataProvider
        collectionView.delegate = mockDataProvider
        mockDataProvider.registerCellIdentifiers(collectionView)
        
        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! MockCell
        
        XCTAssertTrue(cell.configCellGotCalled, "configCell() should get called")
    }
    
    func testConfigCellSetsCorrectItem() {
        let mockDataProvider = MockDataProvider()
        mockDataProvider.photoManager = PhotoManager()
        let photo = createPhoto(withId: 1)
        mockDataProvider.photoManager!.add(photo)
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = MockCollectionView(frame: CGRectMake(0, 0, 320, 480), collectionViewLayout: layout)
        
        collectionView.dataSource = mockDataProvider
        collectionView.delegate = mockDataProvider
        mockDataProvider.registerCellIdentifiers(collectionView)
        
        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! MockCell

        
        XCTAssertNotNil(cell)

        XCTAssertEqual(cell.photo?.url, photo.url, "Cell should get configured with correct photo")
    }
    
    
    func testSelectingACell_SendsNotification() {
        let phtoto = createPhoto(withId: 1)
        sut.photoManager?.add(phtoto)
        
        expectationForNotification("PhotoSelectedNotification", object: nil) { (notification) -> Bool in
            guard let index = notification.userInfo?["index"] as? Int else {
                return false
            }
            return index == 0
        }
                
        collectionView.delegate?.collectionView!(collectionView, didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        waitForExpectationsWithTimeout(3, handler: nil)
    }

    
    private func generateItems(count:Int) -> [Photo] {
        var photos = [Photo]()
        for i in 1...count {
            let item = createPhoto(withId: i)
            photos.append(item)
        }
        return photos
    }
    
    private func createPhoto(withId id:Int) -> Photo {
        let url = NSURL(string: "http://example\(id).com")!
        let item = PhotoItem(url: url, thumbnailURL: url,
                             title: "Title \(id)")
        return item
    }
    
    class MockCollectionView: UICollectionView {
        
        var cellGotDequeed = false
        
        override func cellForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell? {
           return dataSource?.collectionView(self, cellForItemAtIndexPath: indexPath)
        }
        
        override func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            cellGotDequeed = true
            return super.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        }
    }
    
    class MockDataProvider: GalleryDataProvider {
        override func registerCellIdentifiers(collectionView: UICollectionView) {
            collectionView.registerClass(MockCell.self, forCellWithReuseIdentifier: "MockCell")
        }
        
        override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MockCell", forIndexPath: indexPath) as! MockCell
            if let item = photoManager?.itemAtIndex(indexPath.item) {
                cell.configCell(withItem: item)
            }
            return cell
        }
    }
    
    class MockCell: GalleryCollectionViewCell {
        var configCellGotCalled = false
        
        override func configCell(withItem item: Photo) {
            configCellGotCalled = true
            super.configCell(withItem: item)
        }
    }
}
