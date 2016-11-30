//
//  ImageService.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

class ImageService {
    fileprivate var search: String?
    
    fileprivate var networking: Networking?
    
    /**
     Get photos for search term
     
     - Parameter search: A keyword to search photos on
     - Parameter completion: block to handle completion with optional array of `Photo`
     */
    func getPhotos(_ search: String, page: Int, completion: @escaping (NSError?, [Photo]?) -> Void) {
        self.search = search
        
        let failureError = NSError(domain: "Failure", code: 000, userInfo: nil)
        guard let request: URLRequest = .photos(search, pageNumber: page) else {
            completion(failureError, nil)
            return
        }
        
        networking = Networking(request: request) { error, data in
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            guard let info = data?.toJSON() as? [String: Any] else {
                completion(failureError, nil)
                return
            }
            guard let photosInfo = info[Parser.PhotoSearchAPIDefinition.Photos.apiKey] as? [[String: Any]] else {
                completion(failureError, nil)
                return
            }
            
            var photos = [Photo]()
            
            photosInfo.forEach {
                let photo = Photo(json: $0)
                if photo.isValid {
                    photos.append(photo)
                }
            }
            
            completion(nil, photos)
        }
    }
}
