//
//  PhotoLoaderTests.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import XCTest
@testable import FlickrPartyTDD

class PhotoLoaderTests: XCTestCase {
    
    var sut:PhotoLoader!
    
    override func setUp() {
        sut = FlickrPhotoLoader(apiService: MockAPIService(), parser: FlickrResponseParser())
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testPhotoLoader_LoadsPhotos() {
        sut.loadPhotos(1) { (result, error) in
            XCTAssertNotNil(result)
        }
    }
    
    func testPhotoLoader_WithoutMock_LoadsPhotos() {
        if TestRunnerHelper.skipTestsWithNetworkCalls {
            return
        }
        let sut = FlickrPhotoLoader(apiService: FlickrAPIService(), parser: FlickrResponseParser())
        let expectation = expectationWithDescription("LoadPhotosfromAPI")
        sut.loadPhotos(1) { (result, error) in
            if let result = result {
                print(result)
                expectation.fulfill()
            }
        }
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testPhotoLoader_OnError_HandlesError() {
        let sut = FlickrPhotoLoader(
            apiService: MockAPIServiceWithError(),
            parser: FlickrResponseParser())
        let expectation = expectationWithDescription("PhotoLoader should return error")
        sut.loadPhotos { (result, error) in
            if let _ = error {
                expectation.fulfill()
            }
        }
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}

extension PhotoLoaderTests {
    class MockAPIService: FlickrAPIService {
        override func search(tag: String, pageNumber: Int, completion: Handler) {
            completion(result: PhotoLoaderTests.sampleResponse, error: nil)
        }
    }
    
    class MockAPIServiceWithError: FlickrAPIService {
        override func search(tag: String, pageNumber: Int, completion: Handler) {
            completion(result: nil, error: ServiceError.RequestFailed)
        }
    }
}

extension PhotoLoaderTests {
    private static let sampleResponse = "{\"photos\":{\"page\":1,\"pages\":7446,\"perpage\":36,\"total\":\"268037\",\"photo\":[{\"id\":\"29188984311\",\"owner\":\"9374288@N06\",\"secret\":\"e01baf9c1d\",\"server\":\"8531\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29267711575\",\"owner\":\"9374288@N06\",\"secret\":\"0da6b23dec\",\"server\":\"8200\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29188980951\",\"owner\":\"9374288@N06\",\"secret\":\"139b3b6643\",\"server\":\"8091\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28646589313\",\"owner\":\"9374288@N06\",\"secret\":\"f9a4df2cf3\",\"server\":\"7774\",\"farm\":8,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29188977271\",\"owner\":\"9374288@N06\",\"secret\":\"197fc0fffc\",\"server\":\"8628\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28646584083\",\"owner\":\"9374288@N06\",\"secret\":\"592180f377\",\"server\":\"8401\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29188973501\",\"owner\":\"9374288@N06\",\"secret\":\"5dc91daa51\",\"server\":\"8025\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28646579043\",\"owner\":\"9374288@N06\",\"secret\":\"978c500df1\",\"server\":\"8576\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29188970021\",\"owner\":\"9374288@N06\",\"secret\":\"d00bee10f3\",\"server\":\"7531\",\"farm\":8,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28646573613\",\"owner\":\"9374288@N06\",\"secret\":\"528d57d375\",\"server\":\"8141\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29188966791\",\"owner\":\"9374288@N06\",\"secret\":\"b40974bf3b\",\"server\":\"8339\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28646569493\",\"owner\":\"9374288@N06\",\"secret\":\"50d681d172\",\"server\":\"8244\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159334352\",\"owner\":\"9374288@N06\",\"secret\":\"e23961c3e2\",\"server\":\"8289\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159333172\",\"owner\":\"9374288@N06\",\"secret\":\"a2aaf28895\",\"server\":\"8456\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159331672\",\"owner\":\"9374288@N06\",\"secret\":\"60dd39208c\",\"server\":\"8226\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159330422\",\"owner\":\"9374288@N06\",\"secret\":\"e855afc0da\",\"server\":\"8227\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159329172\",\"owner\":\"9374288@N06\",\"secret\":\"bf1ec94bb0\",\"server\":\"8818\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159327602\",\"owner\":\"9374288@N06\",\"secret\":\"4c0183af99\",\"server\":\"8286\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159326082\",\"owner\":\"9374288@N06\",\"secret\":\"7e97c6667d\",\"server\":\"8284\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159324322\",\"owner\":\"9374288@N06\",\"secret\":\"11efff4b6f\",\"server\":\"8100\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159322822\",\"owner\":\"9374288@N06\",\"secret\":\"0de9c19437\",\"server\":\"8010\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159321742\",\"owner\":\"9374288@N06\",\"secret\":\"2c80b40489\",\"server\":\"8252\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29159320112\",\"owner\":\"9374288@N06\",\"secret\":\"857d045dd1\",\"server\":\"8228\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29233186696\",\"owner\":\"9374288@N06\",\"secret\":\"2b6a37bd62\",\"server\":\"8322\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29267664935\",\"owner\":\"9374288@N06\",\"secret\":\"44f6d702d5\",\"server\":\"8104\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29233184476\",\"owner\":\"9374288@N06\",\"secret\":\"0823f80748\",\"server\":\"7776\",\"farm\":8,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29267658125\",\"owner\":\"9374288@N06\",\"secret\":\"e8abfc3044\",\"server\":\"8041\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28979265250\",\"owner\":\"9374288@N06\",\"secret\":\"c1fe521ffe\",\"server\":\"8387\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29267651405\",\"owner\":\"9374288@N06\",\"secret\":\"29e03a3546\",\"server\":\"8020\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28979263170\",\"owner\":\"9374288@N06\",\"secret\":\"79f4792dc2\",\"server\":\"8340\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29267646765\",\"owner\":\"9374288@N06\",\"secret\":\"bf301cbfd5\",\"server\":\"8208\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28979261740\",\"owner\":\"9374288@N06\",\"secret\":\"2c5e5cf16a\",\"server\":\"8568\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"29267642055\",\"owner\":\"9374288@N06\",\"secret\":\"28925d75a2\",\"server\":\"7512\",\"farm\":8,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28979260350\",\"owner\":\"9374288@N06\",\"secret\":\"b2e8ea7696\",\"server\":\"8246\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28979259110\",\"owner\":\"9374288@N06\",\"secret\":\"3611b1a679\",\"server\":\"8206\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},{\"id\":\"28646539483\",\"owner\":\"9374288@N06\",\"secret\":\"4a32269076\",\"server\":\"8522\",\"farm\":9,\"title\":\"Summer Reading Program 2016 - Winners of the Gold Medal Pool Party\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0}]},\"stat\":\"ok\"}"
}