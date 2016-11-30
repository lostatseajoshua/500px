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
    fileprivate(set) var photos = [Photo]()
    fileprivate var activityIndicator: UIActivityIndicatorView?
    fileprivate var searchTerm: String?
    fileprivate var currentPage = 1
    fileprivate var loading = false
    
    fileprivate struct Identifiers {
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
    
    func searchForPhotos(_ term: String) {
        toggleLoading(true)
        loading = true
        view.isUserInteractionEnabled = false
        imageService.getPhotos(term, page: 1) {[weak self] error, photos in
            defer {
                DispatchQueue.main.async {
                    self?.toggleLoading(false)
                    self?.loading = false
                    self?.view.isUserInteractionEnabled = true
                }
            }
            guard let photos = photos, error == nil else {
                DispatchQueue.main.async {
                    self?.onSearchError()
                }
                return
            }
            
            self?.photos = photos
            self?.searchTerm = term
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func onSearchError() {
        let alert = UIAlertController(title: "Failure to search", message: "Oops look like something went wrong", preferredStyle: .alert)
        
        let repeatSearchAction = UIAlertAction(title: "Try again", style: .default) { alert in
            if let text = self.searchTextField.text, !text.isEmpty {
                self.searchForPhotos(text)
            }
        }
        
        let dismissAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(dismissAction)
        alert.addAction(repeatSearchAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func toggleLoading(_ flag: Bool) {
        if flag && activityIndicator == nil {
            // create activity
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activity.hidesWhenStopped = true
            activity.startAnimating()
            
            // add to view
            view.addSubview(activity)
            
            // add constraints
            activity.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints([NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)])
            
            self.activityIndicator = activity
        } else {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
    
    fileprivate func loadMore() {
        guard let searchTerm = searchTerm, !loading else {
            return
        }
        loading = true
        
        imageService.getPhotos(searchTerm, page: currentPage + 1) {[weak self] error, photos in
            defer {
                DispatchQueue.main.async {
                    self?.toggleLoading(false)
                    self?.loading = false
                }
            }
            
            guard let photos = photos, error == nil else {
                return
            }
            
            if let strongSelf = self {
                strongSelf.photos += photos
                strongSelf.currentPage += 1
                DispatchQueue.main.async {
                    strongSelf.collectionView.reloadData()
                }
            }
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == Identifiers.photoDetailsSegueId {
            if let detailsVC = segue.destination as? PhotoDetailsViewController {
                if let indexOfCell = collectionView.indexPathsForSelectedItems?.first {
                    detailsVC.photo = photos.element(atIndex: indexOfCell.row)
                }
            }
        }
    }
}

// MARK: UITextFieldDelegate

extension PhotosCollectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            searchForPhotos(text)
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UICollectionViewDataSource

extension PhotosCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !photos.isEmpty {
           return photos.count + 1
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == photos.count {
            loadMore()
            return collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.activityCollectionCellReuseId, for: indexPath)
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.photoCollectionCellReuseId, for: indexPath) as? PhotoCollectionViewCell {
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var multipler: CGFloat = 2
        let spacing: CGFloat = 40
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            multipler = 5
        }
        
        if indexPath.row == photos.count {
            return CGSize(width: (UIScreen.main.bounds.width - spacing) / multipler, height: (UIScreen.main.bounds.width / multipler) - spacing)
        }
        return CGSize(width: (UIScreen.main.bounds.width - spacing) / multipler, height: (UIScreen.main.bounds.width / multipler))
    }
}
