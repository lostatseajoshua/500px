//
//  Photo.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation
import UIKit

class Photo: JSONDecodable {
    private var networking: Networking?
    private var image: UIImage?
    private var imageURL: String?
    private var valid: Bool
    private var loading = false
    
    var description: String
    var rating: Int
    var id: Int
    var name: String
    
    var isValid: Bool {
        return valid
    }
    
    init() {
        valid = true
        
        description = ""
        name = ""
        rating = 0
        id = 0
    }
    
    required init(json: [NSObject: AnyObject]) {
        imageURL = json.getValue(forKey: Parser.PhotoAPIDefinition.ImageURL.apiKey, defaultValue: "")
        description = json.getValue(forKey: Parser.PhotoAPIDefinition.Description.apiKey, defaultValue: "")
        rating = json.getValue(forKey: Parser.PhotoAPIDefinition.Rating.apiKey, defaultValue: 0)
        id = json.getValue(forKey: Parser.PhotoAPIDefinition.Id.apiKey, defaultValue: 0)
        name = json.getValue(forKey: Parser.PhotoAPIDefinition.Name.apiKey, defaultValue: "")
        valid = !json.getValue(forKey: Parser.PhotoAPIDefinition.Nsfw.apiKey, defaultValue: false)
    }
    
    func getImage(completion: UIImage? -> Void) {
        if let image = self.image {
            completion(image)
        } else {
            if let urlString = imageURL {
                getImageFromURL(urlString, completion: completion)
            }
        }
    }
    
    private func getImageFromURL(url: String, completion: UIImage? -> Void) {
        guard let url = NSURL(string: url) where !loading else {
            completion(nil)
            return
        }
        
        loading = true
        
        networking = Networking(url: url) { data in
            defer {
                self.loading = false
                self.networking = nil
            }
            guard let data = data else {
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                self.image = image
                completion(image)
            }
        }
    }
}