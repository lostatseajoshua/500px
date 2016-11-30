//
//  PhotoDetailsViewController.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        photoImageView.image = photo?.getImage {[weak self] image in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self?.photoImageView.image = image
            }
        }
        nameLabel.text = photo?.name ?? "-"
        if let rating = photo?.rating {
            ratingLabel.text = "Rating: \(rating)"
        } else {
            ratingLabel.text = "Rating: 0"
        }
        contextLabel.text = photo?.description ?? "No description"
    }
}
