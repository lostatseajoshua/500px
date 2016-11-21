//
//  PhotoCollectionViewCell.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private(set) var photo: Photo?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        contextLabel.text = nil
        activityIndicator.stopAnimating()
    }
    
    func load(p: Photo) {
        photo = p
        
        toggleLoading(true)
        photo?.getImage {[weak self] image in
            defer {
                dispatch_async(dispatch_get_main_queue()) {
                    self?.toggleLoading(false)
                }
            }
            guard let image = image else {
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                self?.imageView.image = image
            }
        }
        
        contextLabel.text = photo?.description ?? "No Description"
    }
    
    private func toggleLoading(flag: Bool) {
        if flag {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
