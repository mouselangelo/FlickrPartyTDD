//
//  PhotoManager.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 27/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import Foundation

class PhotoManager {

    static let DataChangeNotificationName = "PhotoManagerDataChanged"
    static let NetworkCallFailedNotificationName = "PhotoLoaderError.NetworkCallFailed"

    private var currentPage = 1
    private var lastFetchedPage = 0
    private var lastFetchFailed = false

    private var loader: PhotoLoader?

    private var photos = [Photo]()

    private (set) var hasMore = true

    init() {
        self.loader = nil
    }

    init(loader: PhotoLoader) {
        self.loader = loader
    }

    func loadPhotos() {
        loader?.loadPhotos(currentPage, completion: { (result, error) in
            guard error == nil else {
                self.lastFetchFailed = true
                self.currentPage = self.lastFetchedPage
                self.handleError(error)
                return
            }
            guard let result = result else { return }
            self.lastFetchedPage = self.currentPage
            self.addAll(result.photos)
            self.hasMore = self.count < result.totalCount
        })
    }

    func loadMore() {
        if currentPage == lastFetchedPage + 1 {
            return
        }
        currentPage = lastFetchedPage + 1
        loadPhotos()
    }

    func resume() {
        if lastFetchFailed {
            lastFetchFailed = false
            loadMore()
        }
    }

    private func handleError(error: PhotoLoaderError?) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            PhotoManager.NetworkCallFailedNotificationName,
            object: self,
            userInfo: nil)
    }

    private func dataChanged() {
        NSNotificationCenter.defaultCenter().postNotificationName(
            PhotoManager.DataChangeNotificationName, object: self)
    }

    /**
        Returns the count of Photos
     - returns Count of photos
     */
    var count: Int {
        return photos.count
    }

    /**
     Adds a single Photo
     - parameter photo: The Photo to add
     */
    func add(photo: Photo) {
        photos.append(photo)
        dataChanged()
    }

    /**
     Returns the item at a given index or nil
     - parameter index: The index (Int)
     - returns: The Photo (or nil) at the given index
     */
    func itemAtIndex(index: Int) -> Photo? {
        guard index >= 0 && index < photos.count else {
            return nil
        }

        return photos[index]
    }

    /**
     Removes all Photos
     */
    func removeAll() {
        photos.removeAll()
        dataChanged()
    }

    /**
     Adds all Photos from given array of Photos
     - parameter items: Array of Photos to be added
     */
    func addAll(items: [Photo]) {
        photos.appendContentsOf(items)
        dataChanged()
    }

}
