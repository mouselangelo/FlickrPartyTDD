//
//  PhotoViewController.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    typealias PhotoInfo = (PhotoManager, Int)
    
    private let config = ScrollConfig()

    var scrollView: UIScrollView?
    var imageView: UIImageView?
    var photoInfo: PhotoInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orangeColor()
        initScrollView()
        initImageView()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func initScrollView() {
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.minimumZoomScale = config.minimumZoomScale
        scrollView?.maximumZoomScale = config.maximumZoomScale
        
        view.addSubViewPinningEdges(scrollView!)
        
        scrollView?.delegate = self
    }
    
    func initImageView() {
        imageView = UIImageView()
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.addSubview(imageView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    private func updateView() {
        // set the title of the navigation item
        guard let info = photoInfo else { return }
        
        guard let photo = info.0.itemAtIndex(info.1) else { return }
        
        navigationItem.title = photo.title
    }
}

extension PhotoViewController {
    
    
    struct ScrollConfig {
        let minimumZoomScale: CGFloat = 0.5
        let maximumZoomScale: CGFloat = 2.0
    }
}
