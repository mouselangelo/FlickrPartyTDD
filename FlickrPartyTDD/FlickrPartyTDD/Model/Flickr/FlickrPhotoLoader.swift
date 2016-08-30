//
//  FlickrPhotoLoader.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class FlickrPhotoLoader: NSObject, PhotoLoader {

    private let apiService: FlickrAPIService
    private let parser: FlickrResponseParser
    private var queue: NSOperationQueue?

    private var completion: ((result: PhotoResponse?, error: PhotoLoaderError?) -> Void)?

    private var json: String?
    private var data: PhotoResponse?

    init(apiService: FlickrAPIService, parser: FlickrResponseParser) {
        self.apiService = apiService
        self.parser = parser
    }

    func loadPhotos(
        page: Int = 1,
        completion: (result: PhotoResponse?, error: PhotoLoaderError?) -> Void) {

        self.completion = completion
        startOperations(page)

    }

    private func registerQueueKVO() {
        queue?.addObserver(self,
                           forKeyPath: "operations",
                           options: NSKeyValueObservingOptions.init(rawValue: 0),
                           context: nil)
    }

    private func startOperations(page: Int) {
        queue = NSOperationQueue()
        registerQueueKVO()

        let downloadOperation = APIOperation(apiService: apiService, page: page)

        downloadOperation.completionBlock = {
            self.json = downloadOperation.json
        }

        let parseOperation = NSBlockOperation {
            guard let json = self.json else {
                self.queue?.cancelAllOperations()
                return
            }
            self.parser.parse(json) { (result, totalCount, error) in
                if let result = result {
                    self.data = PhotoResponse(photos: result, totalCount: totalCount)
                }
            }
        }

        parseOperation.addDependency(downloadOperation)

        queue?.addOperations([downloadOperation, parseOperation], waitUntilFinished: false)
    }

    override func observeValueForKeyPath(
        keyPath: String?,
        ofObject object: AnyObject?,
                 change: [String : AnyObject]?,
                 context: UnsafeMutablePointer<Void>) {
        if object === self.queue && keyPath == "operations" {
            if self.queue?.operations.count == 0 {
                self.onFinished()
            }
        } // else ignore
    }

    private func onFinished() {
        queue = nil
        guard let completion = completion else { cleanup(); return }
        NSOperationQueue.mainQueue().addOperationWithBlock {
            guard let data = self.data else {
                completion(result: nil, error: PhotoLoaderError.NetworkCallFailed)
                self.cleanup()
                return
            }
            completion(result: data, error: nil)
            self.cleanup()
        }
    }

    private func cleanup() {
        self.completion = nil
        self.json = nil
        self.data = nil
    }
}

extension FlickrPhotoLoader {

    class APIOperation: ConcurrentOpertion {

        let apiService: FlickrAPIService
        private var page: Int
        var json: String?

        init(apiService: FlickrAPIService, page: Int = 1) {
            self.apiService = apiService
            self.page = page
        }

        override func start() {
            if cancelled {
                state = .Finished
            } else {
                main()
                state = .Executing
            }
        }

        override func main() {
            self.apiService.search("party", pageNumber: page) { (result, error) in
                guard error == nil else {
                    self.state = .Finished
                    return
                }
                if let result = result {
                    self.json = result
                    self.state = .Finished
                }
            }
        }
    }

}
