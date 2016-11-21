//
//  PhotosCollectionViewController.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let imageService = ImageService()
    private(set) var photos = [Photo]()
    private var activityIndicator: UIActivityIndicatorView?
    private var searchTerm: String?
    private var currentPage = 0
    private var loading = false
    
    private struct Identifiers {
        static let photoCollectionCellReuseId = "PhotoCollectionCellId"
        static let activityCollectionCellReuseId = "ActivityCollectionCellId"
        static let photoDetailsSegueId = "PhotoDetailSegueId"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        photos.removeAll()
    }
    
    func searchForPhotos(term: String) {
        if term != searchTerm {
            toggleLoading(true)
            loading = true
            imageService.getPhotos(term, page: 1) {[weak self] photos in
                defer {
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.toggleLoading(false)
                        self?.loading = false
                    }
                }
                guard let photos = photos else {
                    return
                }
                
                self?.photos = photos
                self?.searchTerm = term
                dispatch_async(dispatch_get_main_queue()) {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    private func toggleLoading(flag: Bool) {
        if flag && activityIndicator == nil {
            // create activity
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activity.hidesWhenStopped = true
            activity.startAnimating()
            
            // add to view
            view.addSubview(activity)
            
            // add constraints
            activity.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([NSLayoutConstraint(item: activity, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: activity, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0)])
            
            self.activityIndicator = activity
        } else {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
    
    func loadMore() {
        guard let searchTerm = searchTerm where !loading else {
            return
        }
        loading = true
        
        imageService.getPhotos(searchTerm, page: currentPage + 1) {[weak self] photos in
            defer {
                dispatch_async(dispatch_get_main_queue()) {
                    self?.toggleLoading(false)
                    self?.loading = false
                }
            }
            guard let photos = photos else {
                return
            }
            
            if let strongSelf = self {
                strongSelf.photos += photos
                strongSelf.currentPage += 1
                dispatch_async(dispatch_get_main_queue()) {
                    strongSelf.collectionView.reloadData()
                }
            }
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == Identifiers.photoDetailsSegueId {
            if let detailsVC = segue.destinationViewController as? PhotoDetailsViewController {
                if let indexOfCell = collectionView.indexPathsForSelectedItems()?.first {
                    detailsVC.photo = photos.element(atIndex: indexOfCell.row)
                }
            }
        }
    }
}

// MARK: UITextFieldDelegate

extension PhotosCollectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text where !text.isEmpty {
            searchForPhotos(text)
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UICollectionViewDataSource

extension PhotosCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !photos.isEmpty {
           return photos.count + 1
        }
        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == photos.count {
            loadMore()
            return collectionView.dequeueReusableCellWithReuseIdentifier(Identifiers.activityCollectionCellReuseId, forIndexPath: indexPath)
        }
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Identifiers.photoCollectionCellReuseId, forIndexPath: indexPath) as? PhotoCollectionViewCell {
            if let photo = photos.element(atIndex: indexPath.row) {
                cell.load(photo)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var multipler: CGFloat = 2
        let spacing: CGFloat = 40
        
        if UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) {
            multipler = 5
        }
        
        if indexPath.row == photos.count {
            return CGSize(width: (UIScreen.mainScreen().bounds.width - spacing) / multipler, height: (UIScreen.mainScreen().bounds.width / multipler) - spacing)
        }
        return CGSize(width: (UIScreen.mainScreen().bounds.width - spacing) / multipler, height: (UIScreen.mainScreen().bounds.width / multipler))
    }
}
