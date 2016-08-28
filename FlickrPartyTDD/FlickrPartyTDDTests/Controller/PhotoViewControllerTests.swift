//
//  PhotoViewControllerTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class PhotoViewControllerTests: XCTestCase {
    
    var sut: PhotoViewController!
    var photoManager: PhotoManager!
    var photo:Photo!
    
    override func setUp() {
        sut = PhotoViewController()
        _ = sut.view
        photoManager = PhotoManager()
        let testURL = NSURL(string: "http://example.com")!
        photo = PhotoItem(url: testURL, thumbnailURL: testURL, title: "Photo Title")
        
        photoManager.add(photo)
        
        sut.photoInfo = (photoManager, 0)
    }
    
    func testSUT_IsNotNil() {
        XCTAssertNotNil(sut, "PhotoViewController should have been initialized")
    }
    
    func testPhotoPhotoInfoIsSet() {
        XCTAssertNotNil(sut.photoInfo, "PhotoInfo must be set")
    }
    
    func testAfterViewDidLoad_ScrollViewIsSet() {
        XCTAssertNotNil(sut.scrollView, "ScrollView should have been initialized")
    }
    
    func testAfterViewDidLoad_ImageViewIsSet() {
        XCTAssertNotNil(sut.imageView, "ImageView should have been initialized")
    }
    
    func testImageView_IsSubViewOfScrollView() {
        XCTAssertTrue(sut.imageView!.isDescendantOfView(sut.scrollView!), "ImageView should be subview of ScrollView")
    }
    
    func testSUTAfterViewWillAppear_SetsNavigationItemTitle_ToPhotosTitile() {
        // force calling viewWillAppear
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        let sutTitle = sut.navigationItem.title
        let expectedTitle = photo.title!
        
        XCTAssertEqual(sutTitle, expectedTitle, "NavigationItem title should match photo's title")
    }
    
}
