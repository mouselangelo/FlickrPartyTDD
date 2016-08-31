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

    override func tearDown() {
        sut = nil
    }

    func testAfterViewDidLoad_NavigationItem_HasTitleFlickrParty() {
        XCTAssertEqual(sut.navigationItem.title,
                       "FlickrParty",
                       "Title should be FlickrParty")
    }

    func testAfterViewDidLoad_CollectionViewIsInitialized() {
        XCTAssertNotNil(sut.collectionView,
                        "Collection view should be initialized after viewDidLoad")
    }


    func testCollectionView_AfterViewDidLoad_ShouldHaveDataSource() {
        XCTAssertNotNil(sut.collectionView?.dataSource,
                        "Collection view dataSource must be set")
        XCTAssertTrue(sut.collectionView?.dataSource is GalleryDataProvider)
    }

    func testCollectionView_AfterViewDidLoad_ShouldHaveDelegate() {
        XCTAssertNotNil(sut.collectionView?.delegate,
                        "Collection view delegate must be set")
        XCTAssertTrue(sut.collectionView?.delegate is GalleryViewController,
                      "VC must be delegate")
    }

    func testGallertVC_DataProvider_HasPhotoManager() {
        XCTAssertNotNil(sut.dataProvider?.photoManager)
    }

    func testOnPhotoSelected_PushedPhotoVC() {
        // use a mock NavigationViewController to verify
        let mockingNavigationController = MockNavigationController(rootViewController: sut)

        // set the mocking navigationVC as the root view controller
        UIApplication.sharedApplication()
            .keyWindow?.rootViewController = mockingNavigationController

        _ = sut.view

        let photo: Photo = PhotoItem(url: NSURL(string: "")!, thumbnailURL: NSURL(string: "")!)
        sut.dataProvider?.photoManager?.add(photo)

        sut.collectionView.delegate?
            .collectionView?(sut.collectionView,
                             didSelectItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))

        guard let photoVC =
            mockingNavigationController.pushedViewController as? PhotoViewController else {
            XCTFail("PhotoViewController should have been pushed")
            return
        }

        guard let photoVCPhoto = photoVC.photo else {
            XCTFail("Photo should have been set")
            return
        }

        XCTAssertEqual(photoVCPhoto.url, photo.url, "Should be the same photo")

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
