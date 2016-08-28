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
        _ = sut.view
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
    
    
    
    
    
}
