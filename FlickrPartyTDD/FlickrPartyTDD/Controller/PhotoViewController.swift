//
//  PhotoViewController.swift
//  FlickrPartyTDD
//
//  Created by Chetan Agarwal on 28/08/16.
//  Copyright © 2016 DeuxLapins. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    typealias PhotoInfo = (PhotoManager, Int)
    
    var scrollView: UIScrollView?
    var imageView: UIImageView?
    var photoInfo: PhotoInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScrollView()
        initImageView()
    }
    
    func initScrollView() {
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewPinningEdges(scrollView!)
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
