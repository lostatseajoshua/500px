//
//  NSURLRequest+Extension.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

extension NSURLRequest {
    enum HTTPMethod: String {
        case Get
        case Post
        case Put
        case Delete
    }
    
    static func photos(search: String, pageNumber: Int) -> NSURLRequest? {
        guard let url = NSURLComponents.api500pxPhotosSearchURLComponents(search, pageNumber: "\(pageNumber)").URL where pageNumber > 0 else {
            return nil
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = HTTPMethod.Get.rawValue.uppercaseString
        
        return request
    }
}
