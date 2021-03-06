//
//  ConcurrentOpertion.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 29/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class ConcurrentOpertion: NSOperation {

    // MARK: - Types

    enum State {
        case Ready, Executing, Finished
        func keyPath() -> String {
            switch self {
            case Ready:
                return "isReady"
            case Executing:
                return "isExecuting"
            case Finished:
                return "isFinished"
            }
        }
    }

    // MARK: - Properties

    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath())
            willChangeValueForKey(state.keyPath())
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath())
            didChangeValueForKey(state.keyPath())
        }
    }

    // MARK: - NSOperation

    override var ready: Bool {
        return super.ready && state == .Ready
    }

    override var executing: Bool {
        return state == .Executing
    }

    override var finished: Bool {
        return state == .Finished
    }

    override var asynchronous: Bool {
        return true
    }
}
