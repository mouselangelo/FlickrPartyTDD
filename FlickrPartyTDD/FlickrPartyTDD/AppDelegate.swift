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

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupInitialViewController()
        window?.makeKeyAndVisible()
        return true
    }
    // Sets up the rootViewController of the current window
    private func setupInitialViewController() {
        // Not using storyboards, so initialize the window and set rootViewController manually.
        
        // the initial viewController to be displayed
        let viewController = GalleryViewController()
        let dataProvider = GalleryDataProvider()
        dataProvider.photoManager = PhotoManager()
        let item = PhotoItem(url: NSURL(string: "")!, thumbnailURL: NSURL(string: "")!, title: "Test Title")
        dataProvider.photoManager?.add(item)
        viewController.dataProvider = dataProvider
        
        
        // using navigation controller to present view controller to enable easier navigation in the app
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window?.rootViewController = navigationController
    }
}

