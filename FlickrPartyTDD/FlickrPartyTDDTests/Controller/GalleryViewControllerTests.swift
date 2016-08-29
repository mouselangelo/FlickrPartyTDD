//
//  GalleryViewControllerTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class GalleryViewControllerTests: XCTestCase {
    
    var sut: GalleryViewController!
    
    override func setUp() {
        sut = GalleryViewController()
        sut.dataProvider = GalleryDataProvider()
        sut.dataProvider!.photoManager = PhotoManager()
        _ = sut.view
    }

    func testAfterViewDidLoad_NavigationItem_HasTitleFlickrParty() {
        XCTAssertEqual(sut.navigationItem.title,
                       "FlickrParty",
                       "Title should be FlickrParty")
    }
    
    func testAfterViewDidLoad_CollectionViewIsInitialized() {
        XCTAssertNotNil(sut.collectionView, "Collection view should be initialized after viewDidLoad")
    }
    
    
    func testCollectionView_AfterViewDidLoad_ShouldHaveDataSource() {
        XCTAssertNotNil(sut.collectionView?.dataSource, "Collection view dataSource must be set")
        XCTAssertTrue(sut.collectionView?.dataSource is GalleryDataProvider)
    }
    
    func testCollectionView_AfterViewDidLoad_ShouldHaveDelegate() {
        XCTAssertNotNil(sut.collectionView?.delegate, "Collection view delegate must be set")
        XCTAssertTrue(sut.collectionView?.delegate is GalleryDataProvider)
    }
    
    func testCollectionView_DelegateAndDataSource_ShouldBeSameInstance() {
        XCTAssertEqual(sut.collectionView?.dataSource as? GalleryDataProvider, sut.collectionView?.delegate as? GalleryDataProvider, "DataSource and Delegate should be the same instance")
    }
    
    func testGallertVC_DataProvider_HasPhotoManager() {
        XCTAssertNotNil(sut.dataProvider?.photoManager)
    }
    
    func testPhotoSelectedNotification_PushedPhotoVC() {
        // use a mock NavigationViewController to verify
        let mockingNavigationController = MockNavigationController(rootViewController: sut)
        
        // set the mocking navigationVC as the root view controller
        UIApplication.sharedApplication().keyWindow?.rootViewController = mockingNavigationController
        
        _ = sut.view
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            "PhotoSelectedNotification",
            object: self,
            userInfo: ["index" : 0])
        
        guard let photoVC = mockingNavigationController.pushedViewController as? PhotoViewController else {
            XCTFail("PhotoViewController should have been pushed")
            return
        }
        
        guard let info = photoVC.photoInfo else {
            XCTFail("PhotoInfo should have been set");
            return
        }
        
        let photoManager = sut.dataProvider?.photoManager
        XCTAssertEqual(info.1, 0, "Index should be what we set")
        XCTAssertTrue(info.0 === photoManager, "Same instance of PhotoManager should be used as the GalleryVC")
    }
    
}

extension GalleryViewControllerTests {
    
    class MockNavigationController: UINavigationController {
        
        var pushedViewController: UIViewController?
        
        override func pushViewController(viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
    
}
