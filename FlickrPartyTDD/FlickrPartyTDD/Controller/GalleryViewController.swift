//
//  GalleryViewController.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    // should be injected
    var dataProvider: PhotoDataProvider? {
        didSet {
            registerDataProvider()
        }
    }
    
    lazy var collectionViewLayout = UICollectionViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "FlickrParty"
        
        view.backgroundColor = UIColor.redColor() // test
        
        initCollectionView()

        registerForNotifications()
    }
    
    private func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(handlePhotoSelectedNotification),
            name: "PhotoSelectedNotification",
            object: nil)
    }
    
    func handlePhotoSelectedNotification(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else { fatalError("Invalid UserInfo in Notification") }
        
        guard let photoManager = dataProvider?.photoManager else { return }
        
        let photoInfo = (photoManager, index)
        let photoVC = PhotoViewController()
        photoVC.photoInfo = photoInfo
        navigationController?.pushViewController(photoVC, animated: true)
        print("Pushing... \(photoVC)")
    }

    
    // initializes the collection view, sets its datasource and delegate and adds it to current view
    private func initCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(50, 50) // change later
        collectionView = UICollectionView(frame: self.view.bounds , collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.yellowColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubViewPinningEdges(collectionView)
        registerDataProvider()
    }
    
    private func registerDataProvider() {
        guard let collectionView = collectionView, dataProvider = dataProvider else { return }
        
        collectionView.dataSource = dataProvider
        collectionView.delegate = dataProvider
        dataProvider.registerCellIdentifiers(collectionView)
    }
    
}
