//
//  NSURLRequest+Extension.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

extension URLRequest {
    enum HTTPMethod: String {
        case Get
        case Post
        case Put
        case Delete
    }
    
    static func photos(_ search: String, pageNumber: Int) -> URLRequest? {
        guard let url = URLComponents.api500pxPhotosSearchURLComponents(search, pageNumber: "\(pageNumber)").url, pageNumber > 0 else {
            return nil
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = HTTPMethod.Get.rawValue.uppercased()
        
        return request as URLRequest
    }
}
