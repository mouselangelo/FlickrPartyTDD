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
        XCTAssertTrue(
            sut.imageView!.isDescendantOfView(sut.scrollView!),
            "ImageView should be subview of ScrollView")
    }
    
    func testPhotoVC_IsScrolLViewDelegate() {
        XCTAssertTrue(sut.conformsToProtocol(UIScrollViewDelegate), "PhotoVC must conform to ScrollViewDelegate protocol")
    }
    
    func testPhotoVC_viewForZooming_ShouldBeImageView() {
        
        guard let scrollView = sut.scrollView else {
            XCTFail("View must have scrollview")
            return
        }
        
        guard let viewForScrolling = sut.viewForZoomingInScrollView(scrollView) else {
            XCTFail("viewForZoomingInScrollView must be set")
            return
        }
        
        let imageView = sut.imageView
        
        XCTAssertTrue(viewForScrolling === imageView, "View for scrolling should be ImageView")
        
        
    }
    
    func testScrollView_ShouldNotDisplayIndicators() {
        guard let scrollView = sut.scrollView else {
            XCTFail()
            return
        }
        
        XCTAssertFalse(scrollView.showsHorizontalScrollIndicator, "ScrollView must not show horizontal scroll indicators")
        XCTAssertFalse(scrollView.showsVerticalScrollIndicator, "ScrollView must not show vertical scroll indicators")
    }
    
    func testScrollView_ShouldSetCorrectZoomLevels() {
        guard let scrollView = sut.scrollView else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(scrollView.minimumZoomScale, 0.5)
        XCTAssertEqual(scrollView.maximumZoomScale, 2.0)
    }
    
    func testScrollView_HasViewControllerAsDelegate() {
        XCTAssertNotNil(sut.scrollView?.delegate, "ScrollView delegate should be set")
        XCTAssertTrue(sut.scrollView?.delegate === sut,
                       "VC should be set as delegate")
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
