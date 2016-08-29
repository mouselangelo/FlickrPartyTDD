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
        collectionView.delegate = self
        dataProvider.registerCellIdentifiers(collectionView)
    }
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let photoManager = dataProvider?.photoManager else { return }
        
        let photoInfo = (photoManager, indexPath.item)
        
        let photoVC = PhotoViewController()
        photoVC.photoInfo = photoInfo
        navigationController?.pushViewController(photoVC, animated: true)
        print("Pushing... \(photoVC)")
    }
}
