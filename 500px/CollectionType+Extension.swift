//
//  CollectionType+Extension.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index  {
    /// Returns the element at the specified index if it is within the bounds of collection
    /// - Parameter index: `Index` of object to attempt to retrieve
    /// - Returns: `Element` of `Collection` if within bounds otherwise returns nil
    func element(atIndex index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
