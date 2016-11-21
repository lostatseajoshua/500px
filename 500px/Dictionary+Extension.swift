//
//  Dictionary+Extension.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

extension Dictionary {
    func getValue<T>(forKey key: Key, defaultValue: T) -> T {
        if let objValue = self[key] as? T {
            return objValue
        }
        return defaultValue
    }
}
