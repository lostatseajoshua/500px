//
//  NSData+Extension.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

extension Data {
    func toJSON() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func jsonDescription() -> String? {
        if let jsonDescription = NSString(data: self, encoding: String.Encoding.utf8.rawValue) {
            return jsonDescription as String
        }
        return nil
    }
}
