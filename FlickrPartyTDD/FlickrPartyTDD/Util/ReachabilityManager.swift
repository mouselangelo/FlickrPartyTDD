//
//  ReachabilityManager.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 30/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

/**
 Conforming types can provide status of current network reachability
 */
protocol ReachabilityManager: class {

    /** Returns the current state of the network */
    var isReachable: Bool { get }

    /**
     Starts listening for changes to the network state.
     - attention: It is recommended to stop listening for changes by calling the
     `stopListeningForNetworkNotifications()` method

     - parameter selector: The selector to be called when the notification is received
     */
    func startListeningForNetworkNotifications(listener: ReachabilityListener)

    /**
     Stop listening for changes to the network state.
     */
    func stopListeningForNetworkNotifications(listener: ReachabilityListener)
}

/**
 Conforming types can register for receiving NetworkStatusChangedNotification
 */
@objc protocol ReachabilityListener: class {
    /** Method expected to be called by ReachabilityManager instances
     when network state changes*/
    func onReachabilityChanged(notification: NSNotification)
}

/** Conforming types can provide an instance of ReachabilityManager */
protocol ReachabilityManagerFactory {
    /** Returns the default ReachabilityManager instance */
    static func defaultManager() -> ReachabilityManager
}
