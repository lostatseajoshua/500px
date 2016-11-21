//
//  NSURLComponents+Extension.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

extension NSURLComponents {
    enum Scheme: String {
        case SSL = "https"
        case NonSSL = "http"
    }
    
    struct API500pxIdentifiers {
        static let host = "api.500px.com"
        static let photosPath = "/v1/photos/search"
        static let consumerKey = "L1Yj9o68dZub8KbSSYEdCrQG5G4tapkehKgqYVKt"
    }
    
    /**
     500px API Photo Resources URL components
     
     GET photos/search
     
     - Parameter term: A keyword to search photos for
     - Parameter pageNumber: retrieve photos from a specific page. Page numbering is 1 indexed
     - Returns: `NSURLComponents` object composed of photo resources search URL
    */
    static func api500pxPhotosSearchURLComponents(term: String, pageNumber: String) -> NSURLComponents {
        let components = NSURLComponents()
        components.scheme = Scheme.SSL.rawValue
        components.host = API500pxIdentifiers.host
        components.path = API500pxIdentifiers.photosPath
        components.query = "term=\(term)" + "&consumer_key=\(API500pxIdentifiers.consumerKey)" + "&page=\(pageNumber)&image_size=3"
        return components
    }
}
