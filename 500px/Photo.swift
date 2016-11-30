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
    fileprivate var networking: Networking?
    fileprivate var image: UIImage?
    fileprivate var imageURL: String?
    fileprivate var valid: Bool
    fileprivate var loading = false
    
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
    
    required init(json: [String: Any]) {
        if let imageURL = json[Parser.PhotoAPIDefinition.ImageURL.apiKey] as? String {
            self.imageURL = imageURL
        }
        imageURL = json.getValue(forKey: Parser.PhotoAPIDefinition.ImageURL.apiKey, defaultValue: "")
        description = json.getValue(forKey: Parser.PhotoAPIDefinition.Description.apiKey, defaultValue: "")
        rating = json.getValue(forKey: Parser.PhotoAPIDefinition.Rating.apiKey, defaultValue: 0)
        id = json.getValue(forKey: Parser.PhotoAPIDefinition.Id.apiKey, defaultValue: 0)
        name = json.getValue(forKey: Parser.PhotoAPIDefinition.Name.apiKey, defaultValue: "")
        valid = !json.getValue(forKey: Parser.PhotoAPIDefinition.Nsfw.apiKey, defaultValue: false)
    }
    
    func getImage(_ completion: @escaping (UIImage?) -> Void) -> UIImage? {
        if let image = self.image {
            completion(nil)
            return image
        } else {
            if let urlString = imageURL {
                getImageFromURL(urlString, completion: completion)
            }
        }
        
        return nil
    }
    
    fileprivate func getImageFromURL(_ url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url), !loading else {
            completion(nil)
            return
        }
        
        loading = true
        
        networking = Networking(url: url) { error, data in
            defer {
                self.loading = false
                self.networking = nil
            }
            guard let data = data, error == nil else {
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
