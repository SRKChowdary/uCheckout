//
//  APIChain.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/9/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation
import ABCoreComponent

open class GroupChainAPI <RootT:Codable, NodeT:Codable> {
    
    public typealias TransformingData = (Codable) -> Data?
    
    public var transforming :TransformingData?
    public var root: APIService <RootT>?
    public var node: APIService <NodeT>?

    private var completed: Closure?
    
    public init () {}
    
    public func chain (rootService: APIService <RootT>, nodeService: APIService <NodeT>,  transforming:TransformingData? = nil , completed: Closure? = nil ) {
        
        rootService.observable = self
        nodeService.observable = self
        
        self.transforming = transforming
        self.root = rootService
        self.node = nodeService
        self.completed = completed
        
    }
    
    public func start () {
        root?.start()
    }
}


 extension GroupChainAPI: APIObservable {
    
    public func emit<T>(service: APIService<T>, result: Result<T>) where T : Decodable, T : Encodable {
        
        if (T.self == NodeT.self &&  service.nameType ?? "" == node?.nameType ?? "") {
            completed?()
            return
        }
        
        if let value  = result.outSuccess(), let transformed = transforming?(value) {
            node?.add(data: transformed)
            node?.start()
            return
        }
        
        if let _ = result.outFailure() {
            return
        }
        
        node?.start()
    }
}
