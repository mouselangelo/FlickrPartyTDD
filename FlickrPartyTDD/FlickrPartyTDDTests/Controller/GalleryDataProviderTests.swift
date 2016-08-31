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
        sut.registerCellIdentifiers(collectionView)
    }

    override func tearDown() {
        sut = nil
        galleryViewController = nil
        collectionView = nil
    }

    func testNumberOfSections_IsOne() {
        let sections = collectionView.numberOfSections()
        XCTAssertEqual(sections, 1, "Collection view has 1 section")
    }

    // DataProvider returns one extra item (LoadMore/Refresh)
    func testNumberOfItemsInSectionOne_IsCountOfPhotosPlusOne() {
        let photos = generateItems(5)
        sut.photoManager?.addAll(photos)
        XCTAssertEqual(collectionView.numberOfItemsInSection(0), 6,
                       "Should contain same items as added (5) + 1")

        sut.photoManager?.add(createPhoto(withId: 6))
        collectionView.reloadData()
        XCTAssertEqual(collectionView.numberOfItemsInSection(0), 7,
                       "Should contain same items as added (6) + 1 ")
    }

    func testCellForItem_ReturnsGalleryCollectionViewCell() {

        let collectionView = MockCollectionView(
            frame: CGRect(x: 0, y: 0, width: 320, height: 480),
            collectionViewLayout: UICollectionViewFlowLayout())

        collectionView.dataSource = sut

        collectionView.registerClass(GalleryCollectionViewCell.self,
                                     forCellWithReuseIdentifier: "GalleryCell")


        let photo = createPhoto(withId: 1)

        sut.photoManager?.add(photo)
        collectionView.reloadData()

        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))

        XCTAssertNotNil(cell, "Cell should have been created")
        XCTAssertTrue(cell is GalleryCollectionViewCell,
                      "Cell should be of type GalleryCollectionViewCell")
    }

    func testCellForItem_ReturnsLoadMoreCell() {

        let collectionView =
            MockCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                               collectionViewLayout: UICollectionViewFlowLayout())

        let sut = GalleryDataProvider()
        let photoManager = PhotoManager()
        sut.photoManager = photoManager

        collectionView.dataSource = sut

        sut.registerCellIdentifiers(collectionView)

        let mockReachabilityManager = MockReachabilityManager()

        mockReachabilityManager.networkStateToReturn = true

        sut.onReachabilityChanged(NSNotification(name: "", object: mockReachabilityManager))

        let photo = createPhoto(withId: 1)

        sut.photoManager?.add(photo)
        collectionView.reloadData()

        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0))

        XCTAssertNotNil(cell, "Cell should have been created")
        XCTAssertTrue(cell is LoadMoreCollectionViewCell,
                      "Cell should be of type LoadMoreCollectionViewCell")
    }

    func testCellForItem_OnNoNetworkReturnsRefreshCell() {

        let collectionView =
            MockCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                               collectionViewLayout: UICollectionViewFlowLayout())

        let sut = GalleryDataProvider()
        let photoManager = PhotoManager()
        sut.photoManager = photoManager

        collectionView.dataSource = sut

        sut.registerCellIdentifiers(collectionView)

        let mockReachabilityManager = MockReachabilityManager()

        sut.onReachabilityChanged(NSNotification(name: "", object: mockReachabilityManager))


        let photo = createPhoto(withId: 1)

        sut.photoManager?.add(photo)

        collectionView.reloadData()

        let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0))

        XCTAssertNotNil(cell, "Cell should have been created")
        XCTAssertTrue(cell is RefreshCollectionViewCell,
                      "Cell should be of type RefreshCollectionViewCell")
    }

    func testCellGetsDequed() {
        let photo = createPhoto(withId: 1)
        sut.photoManager!.add(photo)

        let layout = UICollectionViewFlowLayout()
        let collectionView =
            MockCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                               collectionViewLayout: layout)

        collectionView.dataSource = sut
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
        let collectionView =
            MockCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                               collectionViewLayout: layout)

        collectionView.dataSource = mockDataProvider
        mockDataProvider.registerCellIdentifiers(collectionView)

        guard let cell = collectionView.cellForItemAtIndexPath(
            NSIndexPath(forItem: 0, inSection: 0)) as? MockCell else {
                XCTFail()
                return
        }

        XCTAssertTrue(cell.configCellGotCalled, "configCell() should get called")
    }

    func testConfigCellSetsCorrectItem() {
        let mockDataProvider = MockDataProvider()
        mockDataProvider.photoManager = PhotoManager()
        let photo = createPhoto(withId: 1)
        mockDataProvider.photoManager!.add(photo)

        let layout = UICollectionViewFlowLayout()
        let collectionView =
            MockCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                               collectionViewLayout: layout)

        collectionView.dataSource = mockDataProvider
        mockDataProvider.registerCellIdentifiers(collectionView)

        guard let cell = collectionView.cellForItemAtIndexPath(
            NSIndexPath(forItem: 0, inSection: 0)) as? MockCell else {
                XCTFail()
                return
        }


        XCTAssertNotNil(cell)

        XCTAssertEqual(cell.photo?.url, photo.url,
                       "Cell should get configured with correct photo")
    }


    func testDataProvider_OnDataChangeNotification_callsCollectionViewRealodData() {
        let layout = UICollectionViewFlowLayout()
        let collectionView =
            MockCollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                               collectionViewLayout: layout)

        collectionView.dataSource = sut
        sut.registerCellIdentifiers(collectionView)

        XCTAssertFalse(collectionView.reloadDataGotCalled)

        sut.photoManager?.add(createPhoto(withId: 1))

        XCTAssertTrue(collectionView.reloadDataGotCalled,
                      "collectionView reloadData should get called on data changed")
    }

    func testDataProvider_OnRegister_CallsPhotoManagerLoadPhotos() {
        let layout = UICollectionViewFlowLayout()

        let collectionView =
            UICollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480),
                             collectionViewLayout: layout)

        let mockPhotoManager = MockPhotoManager()

        sut.photoManager = mockPhotoManager
        XCTAssertFalse(mockPhotoManager.loadPhotosCalled)
        sut.registerCellIdentifiers(collectionView)

        XCTAssertTrue(mockPhotoManager.loadPhotosCalled)
    }


    private func generateItems(count: Int) -> [Photo] {
        var photos = [Photo]()
        for i in 1...count {
            let item = createPhoto(withId: i)
            photos.append(item)
        }
        return photos
    }

    private func createPhoto(withId photoId: Int) -> Photo {
        let url = NSURL(string: "http://example\(photoId).com")!
        let item = PhotoItem(url: url, thumbnailURL: url,
                             title: "Title \(photoId)")
        return item
    }
}

extension GalleryDataProviderTests {
    class MockCollectionView: UICollectionView {

        var cellGotDequeed = false
        var reloadDataGotCalled = false

        override func cellForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell? {
            return dataSource?.collectionView(self, cellForItemAtIndexPath: indexPath)
        }

        override func dequeueReusableCellWithReuseIdentifier(
            identifier: String,
            forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

            cellGotDequeed = true
            return super.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        }

        override func reloadData() {
            reloadDataGotCalled = true
            super.reloadData()
        }
    }

    class MockDataProvider: GalleryDataProvider {
        override func registerCellIdentifiers(collectionView: UICollectionView) {
            collectionView.registerClass(MockCell.self, forCellWithReuseIdentifier: "MockCell")
        }

        override func collectionView(
            collectionView: UICollectionView,
            cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                "MockCell", forIndexPath: indexPath) as? MockCell else {
                    return UICollectionViewCell()
            }
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

    class MockPhotoManager: PhotoManager {

        var loadPhotosCalled = false

        override func loadPhotos() {
            loadPhotosCalled = true
            super.loadPhotos()
        }
    }

    class MockReachabilityManager: NSObject, ReachabilityManager {

        var networkStateToReturn: Bool = false

        var isReachable: Bool {
            return networkStateToReturn
        }

        func stopListeningForNetworkNotifications(listener: ReachabilityListener) {
            // ignore
        }
        func startListeningForNetworkNotifications(listener: ReachabilityListener) {
            // ignore
        }
    }
}
