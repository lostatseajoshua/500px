//
//  NSData+Extension.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

extension NSData {
    func toJSON() -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(self, options: .AllowFragments)
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func jsonDescription() -> String? {
        if let jsonDescription = NSString(data: self, encoding: NSUTF8StringEncoding) {
            return jsonDescription as String
        }
        return nil
    }
}
