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
            return self.rawValue.lowercased()
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
            return self.rawValue.lowercased()
        }
    }
}

protocol APIKey {
    var apiKey: String { get }
}

protocol JSONDecodable {
    init(json: [String: Any]) throws
    var isValid: Bool { get }
}
