//
//  ImageService.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

class ImageService {
    private var search: String?
    
    private var networking: Networking?
    
    /**
     Get photos for search term
     
     - Parameter search: A keyword to search photos on
     - Parameter completion: block to handle completion with optional array of `Photo`
     */
    func getPhotos(search: String, page: Int, completion: [Photo]? -> Void) {
        self.search = search
        
        guard let request: NSURLRequest = .photos(search, pageNumber: page) else {
            completion(nil)
            return
        }
        
        networking = Networking(request: request) { data in
            guard let info = data?.toJSON() as? [NSObject: AnyObject] else {
                completion(nil)
                return
            }
            guard let photosInfo = info[Parser.PhotoSearchAPIDefinition.Photos.apiKey] as? [[NSObject: AnyObject]] else {
                completion(nil)
                return
            }
            
            var photos = [Photo]()
            
            photosInfo.forEach {
                let photo = Photo(json: $0)
                if photo.isValid {
                    photos.append(photo)
                }
            }
            
            completion(photos)
        }
    }
}
