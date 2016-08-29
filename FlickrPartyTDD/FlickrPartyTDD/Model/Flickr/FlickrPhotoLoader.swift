//
//  FlickrPhotoLoader.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class FlickrPhotoLoader: PhotoLoader {
    
    private let apiService: FlickrAPIService
    private let parser: FlickrResponseParser
    private var completion: (([Photo]?, NSError?) -> Void)?
    private let queue: NSOperationQueue
    private var json:String?
    private var data:[Photo]?
    
    init(apiService: FlickrAPIService, parser: FlickrResponseParser) {
        self.apiService = apiService
        self.parser = parser
        self.queue = NSOperationQueue()
    }
    
    func loadPhoto(completion: (result:[Photo]?, error:NSError?) -> Void) {
        self.completion = completion
        startOperations()
    }
    
    private func startOperations() {
        let downloadOperation = NSBlockOperation {
            print("Download queue started...")
            self.apiService.search("party", pageNumber: 1) { (result, error) in
                if let result = result {
                    self.json = result
                }
            }
            print("Download queue finished...")
        }
        
        let parseOperation = NSBlockOperation {
            print("Parse queue started...")
            guard let json = self.json else {
                print("Parse queue finished...")
                return
            }
            self.parser.parse(json) { (result, totalCount, error) in
                if let result = result {
                    self.data = result
                }
            }
            print("Parse queue finished...")
        }
        
        parseOperation.addDependency(downloadOperation)
        
        queue.addOperations([downloadOperation, parseOperation], waitUntilFinished: true)
        
        guard let data = data else {
            self.completion!(nil, nil)
            return
        }
        
        self.completion!(data, nil)
    }
}