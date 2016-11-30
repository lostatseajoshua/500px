//
//  Networking.swift
//  500px
//
//  Created by Joshua Alvarado on 11/20/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation

class Networking: NSObject {
    let completion: (NSError?, Data?) -> Void
    fileprivate var data = Data()
    
    lazy fileprivate(set) var session: Foundation.URLSession = {
        Foundation.URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
    }()
    
    init(request: URLRequest, completion: @escaping (NSError?, Data?) -> Void) {
        self.completion = completion
        super.init()
        session.dataTask(with: request).resume()
    }
    
    init(url: URL, completion: @escaping (NSError?, Data?) -> Void) {
        self.completion = completion
        super.init()
        session.dataTask(with: url).resume()
    }
}

extension Networking: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if error != nil {
            completion(error as NSError?, nil)
            return
        }
    }
}

extension Networking: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        defer {
            session.finishTasksAndInvalidate()
        }
        if error != nil {
            completion(error as NSError?, nil)
            return
        }
        completion(nil, data)
    }
}
