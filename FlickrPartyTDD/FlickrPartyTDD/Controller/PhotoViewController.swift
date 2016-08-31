//
//  PhotoViewController.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoViewController: UIViewController, ReachabilityListener {

    private let config = ScrollConfig()

    var reachabilityManager: ReachabilityManager?
    private var networkAlertController: UIAlertController?

    var scrollView: UIScrollView?
    var imageView: UIImageView?

    var photo: Photo?
    var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForReachability()
        view.backgroundColor = UIColor.blackColor()
        initScrollView()
        initImageView()
        initIndicator()
    }

    private func registerForReachability() {
        guard let reachabilityManager = reachabilityManager else { return }
        reachabilityManager.startListeningForNetworkNotifications(self)
        checkForReachability()
    }

    private func checkForReachability() {
        guard let reachabilityManager = reachabilityManager else { return }

        guard reachabilityManager.isReachable else {
            networkAlertController = showNoANetworAlert({
                print("User tapped retry...")
                self.checkForReachability()
            })
            return
        }
        if let _ = networkAlertController {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.networkAlertController = nil
        }
        if imageView?.image == nil {
            updateView()
        }
    }

    func onReachabilityChanged(notification: NSNotification) {
        checkForReachability()
    }

    private func initIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }

    private func initScrollView() {
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.minimumZoomScale = config.minimumZoomScale
        scrollView?.maximumZoomScale = config.maximumZoomScale

        view.addSubViewPinningEdges(scrollView!)

        scrollView?.delegate = self
    }

    private func initImageView() {
        imageView = UIImageView()
        scrollView?.addSubview(imageView!)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.centerImage()
            self.activityIndicator?.center = self.view.center
        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }

    private func updateView() {
        // set the title of the navigation item
        //guard let info = photoInfo else { return }

        guard let photo = photo else { return }

        self.activityIndicator?.startAnimating()
        self.activityIndicator?.hidden = false

        navigationItem.title = photo.title
        imageView?.kf_setImageWithURL(
            photo.url,
            placeholderImage: nil,
            optionsInfo: nil,
            progressBlock: nil,
            completionHandler: {
                (image, error, cacheType, imageURL) in
                guard let image = image else { return }
                self.imageView?.sizeToFit()
                self.scrollView?.contentSize = image.size
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.autoFitImage()
                    self.activityIndicator?.stopAnimating()
                    self.activityIndicator?.hidden = true
                })
        })
    }

    private func autoFitImage() {
        guard let scrollView = scrollView else { return }
        let zoomX = scrollView.bounds.size.width / scrollView.contentSize.width
        let zoomY = (scrollView.bounds.size.height - topMargin()) / scrollView.contentSize.height
        scrollView.zoomScale = min(zoomX, zoomY)
        centerImage()
    }

    private func centerImage() {
        guard let scrollView = scrollView else { return }
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width)/2, 0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height)/2, 0)
        print(offsetX)
        print(offsetY)

        imageView?.center = CGPoint(
            x: scrollView.contentSize.width / 2 + offsetX,
            y: scrollView.contentSize.height / 2 + offsetY - topMargin() / 2)
    }

    private func topMargin() -> CGFloat {
        let navBarHeight = self.navigationController?.navigationBar.bounds.size.height ?? 0
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        return navBarHeight + statusBarHeight
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerImage()
    }
}

extension PhotoViewController {
    struct ScrollConfig {
        let minimumZoomScale: CGFloat = 0.5
        let maximumZoomScale: CGFloat = 2.0
    }
}
