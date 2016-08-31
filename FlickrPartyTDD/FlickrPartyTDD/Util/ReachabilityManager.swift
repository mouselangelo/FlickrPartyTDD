//
//  ReachabilityManager.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 30/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation
import Reachability


@objc enum NetworkState: Int {
    case Unknown
    case Reachable
    case UnReachable
}
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

/** Conforming types can provide an instance of ReachabilityManager */
protocol ReachabilityManagerFactory {
    static func defaultManager() -> ReachabilityManager
}

/** Provides instance of the default ReachabilityManager implementation */
class DefaultReachabilityManagerFactory: ReachabilityManagerFactory {
    static func defaultManager() -> ReachabilityManager {
        return DefaultReachabilityManager.sharedInstance
    }
}

/**
 Conforming types can register for receiving NetworkStatusChangedNotification
 */
@objc protocol ReachabilityListener: class {
    func onReachabilityChanged(notification: NSNotification)
}

class DefaultReachabilityManager: NSObject, ReachabilityManager {

    static let networkStatusChangedNotification = "NetworkStatusChangedNotification"

    static let sharedInstance: DefaultReachabilityManager = DefaultReachabilityManager()

    override init() {
        super.init()
        start()
    }

    var currentState: NetworkState {
        guard let reachability = reachability else {
            return .Unknown
        }

        guard reachability.isReachable() else {
            return .UnReachable
        }

        return .Reachable
    }

    var isReachable: Bool {
        return currentState == .Reachable
    }

    private var reachability: Reachability? = {
        guard let reachabilityObj = try? Reachability.reachabilityForInternetConnection() else {
            print("Unable to create Reachability")
            return nil
        }
        return reachabilityObj
    }()

    func start() {
        guard let reachability = reachability else { return }

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(onReachabilityChanged),
            name: ReachabilityChangedNotification,
            object: reachability)

        _ = try? reachability.startNotifier()
    }

    func onReachabilityChanged(notification: NSNotification) {
        guard let reachability = notification.object as? Reachability else {
            fatalError("Notification should have been fired by Reachability")
        }

        NSNotificationCenter.defaultCenter().postNotificationName(
            DefaultReachabilityManager.networkStatusChangedNotification, object: self)

        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
    }

    func startListeningForNetworkNotifications(listener: ReachabilityListener) {

        NSNotificationCenter.defaultCenter().addObserver(
            listener, selector: #selector(listener.onReachabilityChanged),
            name: DefaultReachabilityManager.networkStatusChangedNotification, object: self)
    }

    func stopListeningForNetworkNotifications(listener: ReachabilityListener) {
        NSNotificationCenter.defaultCenter().removeObserver(
            listener,
            name: DefaultReachabilityManager.networkStatusChangedNotification, object: self)
    }

}
