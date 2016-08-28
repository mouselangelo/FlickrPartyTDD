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
    var dataProvider: PhotoDataProvider?
    
    lazy var collectionViewLayout = UICollectionViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()
        initCollectionView()
    }
    // initializes the collection view, sets its datasource and delegate and adds it to current view
    private func initCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(50, 50) // change later
        collectionView = UICollectionView(frame: self.view.bounds , collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.yellowColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView!.dataSource = dataProvider
        collectionView!.delegate = dataProvider
        dataProvider?.registerCellIdentifiers(collectionView!)
        self.view.addSubViewPinningEdges(collectionView)
    }
}
