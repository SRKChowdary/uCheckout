//
//  ServiceDetails.swift
//  ABCoreComponent
//
//  Created by Ganesh Reddiar on 6/17/19.
//

import Foundation

public struct ServiceConfig {
    public var serviceHost: String?
    public var serviceBase: String?
    public var serviceHeaders:[String:String] = [:]
    public var serviceKey: String?
    public var serviceSecret: String?
    
    public init (
        serviceHost: String? = nil,
        serviceBase: String? = nil,
        serviceHeaders: [String:String] = [:],
        serviceKey: String? = nil,
        serviceSecret: String? = nil
        ) {
       
        self.serviceHost = serviceHost
        self.serviceBase = serviceBase
        self.serviceHeaders = serviceHeaders
        self.serviceSecret = serviceSecret
        self.serviceKey = serviceKey
    }
}

public protocol ServiceConfigContract {
    
    var serviceHost: String? {get set}
    var serviceBase: String? {get set}
    var serviceHeaders:[String:String]? {get set}
    var serviceKey: String? {get set}
    var serviceSecret: String? {get set}
    
}



