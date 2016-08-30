//
//  AppDelegate.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    let reachabilityManager: ReachabilityManager =
        DefaultReachabilityManager.sharedInstance

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {

        print("Reachability: \(reachabilityManager.currentState)")


        setupInitialViewController()
        window?.makeKeyAndVisible()
        return true
    }
    // Sets up the rootViewController of the current window
    private func setupInitialViewController() {
        // Not using storyboards, so initialize the window
        // and set rootViewController manually.

        // the initial viewController to be displayed
        let viewController = GalleryViewController()

        viewController.config = DefaultCollectionViewConfig()
        viewController.reachabilityManager = reachabilityManager

        let apiService = FlickrAPIService()
        let parser = FlickrResponseParser()
        let loader = FlickrPhotoLoader(apiService: apiService, parser: parser)

        let photoManager = PhotoManager(loader: loader)

        let dataProvider = GalleryDataProvider(photoManager: photoManager)
        viewController.dataProvider = dataProvider


        // using navigation controller to present view controller
        // to enable navigation in the app
        let navigationController =
            UINavigationController(rootViewController: viewController)

        window?.rootViewController = navigationController
    }



}
