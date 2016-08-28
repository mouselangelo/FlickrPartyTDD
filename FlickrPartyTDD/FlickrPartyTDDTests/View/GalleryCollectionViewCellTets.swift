//
//  GalleryCollectionViewCellTets.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class GalleryCollectionViewCellTets: XCTestCase {
    
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
    
    func testGalleryCell_IsNotNil() {
        XCTAssertNotNil(sut)
    }
    
    func testGalleryCell_HasImageView() {
        XCTAssertNotNil(sut.imageView, "ImageView should have been initialized")
    }
}

extension GalleryCollectionViewCellTets {
    class FakeDataSource: NSObject, UICollectionViewDataSource {
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            return GalleryCollectionViewCell()
        }
        
    }
}
