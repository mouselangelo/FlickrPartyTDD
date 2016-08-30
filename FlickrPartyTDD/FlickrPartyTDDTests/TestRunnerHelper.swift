//
//  TestRunnerHelper.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 29/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

struct TestRunnerHelper {
    /** Set this to true to skip all the tests that make actual calls to the API or rely on network connections. By default this should be false, but can be set to true for running tests more rapidly*/
    static let skipTestsWithNetworkCalls = false
}