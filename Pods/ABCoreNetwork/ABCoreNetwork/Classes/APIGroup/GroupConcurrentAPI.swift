//
//  ConcurrentAPI.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/16/19.
//

import Foundation

open class GroupConcurrentAPI {
    
    lazy var apiQ = OperationQueue()
    
    public func addService<T:Codable> (service:APIService<T>) {
        let serviceOperation = BlockOperation {service.start()}
        apiQ.addOperation (serviceOperation)
    }
}
