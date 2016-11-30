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
    fileprivate(set) var photo: Photo?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        contextLabel.text = nil
        activityIndicator.stopAnimating()
    }
    
    func load(_ p: Photo) {
        photo = p
        
        toggleLoading(true)
        imageView.image = photo?.getImage {[weak self] image in
            defer {
                DispatchQueue.main.async {
                    self?.toggleLoading(false)
                }
            }
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
        
        contextLabel.text = photo?.description ?? "No Description"
    }
    
    fileprivate func toggleLoading(_ flag: Bool) {
        if flag {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
