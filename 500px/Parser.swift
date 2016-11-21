//
//  Parser.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

struct Parser {
    enum PhotoSearchAPIDefinition: String, APIKey {
        case Photos
        
        var apiKey: String {
            return self.rawValue.lowercaseString
        }
    }
    
    enum PhotoAPIDefinition: String, APIKey {
        case Id
        case Name
        case Description
        case Rating
        case Nsfw
        case ImageURL = "image_url"
        
        var apiKey: String {
            return self.rawValue.lowercaseString
        }
    }
}

protocol APIKey {
    var apiKey: String { get }
}

protocol JSONDecodable {
    init(json: [NSObject: AnyObject]) throws
    var isValid: Bool { get }
}
