//
//  GalleryViewController.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, ReachabilityListener {

    var collectionView: UICollectionView!

    var reachabilityManager: ReachabilityManager?

    var config: CollectionViewConfig!

    private var networkAlertController: UIAlertController?

    private var collectionViewCellSize = CGSize.zero
    private var collectionViewLoadMoreSize = CGSize.zero


    // should be injected
    var dataProvider: PhotoDataProvider? {
        didSet {
            registerDataProvider()
        }
    }

    lazy var collectionViewLayout = UICollectionViewLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        registerForReachability()

        navigationItem.title = "FlickrParty"

        view.backgroundColor = UIColor.whiteColor()

        initCollectionView()
    }

    private func registerForReachability() {
        guard let reachabilityManager = reachabilityManager else { return }

        reachabilityManager.startListeningForNetworkNotifications(self)
        checkForReachability()
    }

    private func checkForReachability() {
        guard let reachabilityManager = reachabilityManager else { return }

        print(reachabilityManager.currentState)

        guard reachabilityManager.currentState == .UnReachable else {
            if let _ = networkAlertController {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.networkAlertController = nil
            }
            return
        }
        networkAlertController = showNoANetworAlert({
            print("User tapped retry...")
            self.checkForReachability()
        })
    }

    func onReachabilityChanged(notification: NSNotification) {
        checkForReachability()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let flowLayout = collectionView.collectionViewLayout as?
            UICollectionViewFlowLayout else {
                return
        }

        guard let config = config else { return }

        let horizontalInset = config.sectionInset * 2

        let isLandscaoe = UIInterfaceOrientationIsLandscape(
            UIApplication.sharedApplication().statusBarOrientation)

        let numCols = isLandscaoe ? config.numColumnsInLandscape : config.numColumnsInPortrait

        let availableWidth =
            (self.view.bounds.width -
                (config.horizontalCellSpacing * (numCols - 1) ))
                - horizontalInset
        let finalWidth = floor(availableWidth/numCols)

        collectionViewCellSize = CGSize(width: finalWidth, height: finalWidth)
        collectionViewLoadMoreSize =
            CGSize(
                width: collectionView.bounds.width - horizontalInset * 2,
                height: finalWidth)


        flowLayout.invalidateLayout()
    }

    // initializes the collection view, sets its datasource and delegate and adds it to current view
    private func initCollectionView() {
        let layout = initFlowLayout()

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubViewPinningEdges(collectionView)
        registerDataProvider()
    }

    private func initFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        if let config = config {
            layout.sectionInset = UIEdgeInsets(
                top: config.sectionInset,
                left: config.sectionInset,
                bottom: config.sectionInset,
                right: config.sectionInset)
            layout.minimumInteritemSpacing = config.horizontalCellSpacing
            layout.minimumLineSpacing = config.verticalCellSpacing
        }
        return layout
    }

    private func registerDataProvider() {
        guard let collectionView = collectionView, dataProvider = dataProvider else { return }

        collectionView.dataSource = dataProvider
        collectionView.delegate = self
        dataProvider.registerCellIdentifiers(collectionView)
    }

}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
                        didSelectItemAtIndexPath indexPath: NSIndexPath) {

        guard indexPath.item < dataProvider?.photoCount else {
            checkForReachability()
            return
        }


        guard let photoManager = dataProvider?.photoManager else { return }

        let photoInfo = (photoManager, indexPath.item)

        let photoVC = PhotoViewController()
        photoVC.photoInfo = photoInfo
        photoVC.reachabilityManager = reachabilityManager
        navigationController?.pushViewController(photoVC, animated: true)
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard indexPath.item < dataProvider?.photoCount else {
            return collectionViewLoadMoreSize
        }
        return collectionViewCellSize
    }

}

protocol CollectionViewConfig {
    var numColumnsInPortrait: CGFloat { get }
    var numColumnsInLandscape: CGFloat { get }
    var horizontalCellSpacing: CGFloat { get }
    var verticalCellSpacing: CGFloat { get }
    var sectionInset: CGFloat { get }
}

struct DefaultCollectionViewConfig: CollectionViewConfig {
    let numColumnsInPortrait: CGFloat = 3.0
    let numColumnsInLandscape: CGFloat = 4.0
    let horizontalCellSpacing: CGFloat = 1.0
    let verticalCellSpacing: CGFloat = 1.0
    let sectionInset: CGFloat = 0.0
}
