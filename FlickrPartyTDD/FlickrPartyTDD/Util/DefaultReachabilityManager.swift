//
//  DefaultReachabilityManager.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 31/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation
import Reachability

/** Default implementation of ReachabilityManger (hides external dependencies) */
class DefaultReachabilityManager: NSObject {

    enum NetworkState: Int {
        case Unknown
        case Reachable
        case UnReachable
    }

    private static let networkStatusChangedNotification = "NetworkStatusChangedNotification"

    static let sharedInstance: DefaultReachabilityManager = DefaultReachabilityManager()

    override init() {
        super.init()
        start()
    }

    private var reachability: Reachability? = {
        guard let reachability = try? Reachability.reachabilityForInternetConnection() else {
            print("Unable to create Reachability")
            return nil
        }
        return reachability
    }()

    private var currentState: NetworkState {
        guard let reachability = reachability else {
            return .Unknown
        }

        guard reachability.isReachable() else {
            return .UnReachable
        }

        return .Reachable
    }

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

}

// MARK: ReachabilityManager protocol

extension DefaultReachabilityManager: ReachabilityManager {
    var isReachable: Bool {
        return currentState == .Reachable
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


/** Provides instance of the default ReachabilityManager implementation */
class DefaultReachabilityManagerFactory: ReachabilityManagerFactory {
    static func defaultManager() -> ReachabilityManager {
        return DefaultReachabilityManager.sharedInstance
    }
}
