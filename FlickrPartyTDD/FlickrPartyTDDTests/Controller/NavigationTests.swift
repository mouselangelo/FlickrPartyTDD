//
//  NavigationTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class NavigationTests: XCTestCase {
    
    var rootViewController: UIViewController!
    
    override func setUp() {
        rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
    }
    
    override func tearDown() {
        rootViewController = nil
    }
    
    func testRootVC_IsNavigationViewController() {
        XCTAssertNotNil(rootViewController, "root VC should have been initialized")
        XCTAssertTrue(rootViewController is UINavigationController, "root VC should be a navigation controller")
    }
    
    func testInitialViewController_IsGalleryViewController() {
        let navVC = rootViewController as! UINavigationController
        let initialVC = navVC.viewControllers.first
        XCTAssertTrue(initialVC is GalleryViewController, "Initial ViewController should be GalleryViewController")
    }
    
}
