//
//  Networking.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

class Networking: NSObject {
    let completion: (NSError?, NSData?) -> Void
    private let data = NSMutableData()
    
    lazy private(set) var session: NSURLSession = {
        NSURLSession(configuration: .ephemeralSessionConfiguration(), delegate: self, delegateQueue: nil)
    }()
    
    init(request: NSURLRequest, completion: (NSError?, NSData?) -> Void) {
        self.completion = completion
        super.init()
        session.dataTaskWithRequest(request).resume()
    }
    
    init(url: NSURL, completion: (NSError?, NSData?) -> Void) {
        self.completion = completion
        super.init()
        session.dataTaskWithURL(url).resume()
    }
}

extension Networking: NSURLSessionDelegate {
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        if error != nil {
            completion(error, nil)
            return
        }
    }
}

extension Networking: NSURLSessionDataDelegate {
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        defer {
            session.finishTasksAndInvalidate()
        }
        if error != nil {
            completion(error, nil)
            return
        }
        completion(nil, data)
    }
}
