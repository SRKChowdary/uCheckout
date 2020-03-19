//-------------------------------------------------------------//
//
//  FunnelAPI.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/15/19.
//
//-------------------------------------------------------------//

import Foundation
import ABCoreComponent


open class GroupDependentAPI {
    
    var main :BlockOperation?
    var dependentList :[BlockOperation] = []
    
    public init (){}

    public func addMain <T:Codable> (service: APIService<T>, completed: Closure?) {
        
        if main?.isExecuting ?? false {return}
        main = BlockOperation {service.start()}
        main?.completionBlock = {completed?()}
    }
    
    public func addDependent <T:Codable> (service:APIService<T>, completed: Closure?) {
        
        let secondary =  BlockOperation {service.start()}
        secondary.completionBlock = {completed?()}
        if let main = main {secondary.addDependency(main)}
        if dependentList.contains(secondary) {return}
        dependentList.append(secondary)
    }
    
/**
Function to support secondary operations i.e service providers or any type of custom implementation of the network layer that would be depenedent on main service ie. token service.
     - Parameters:
        - operation: secondary operation
        - completed: Empty implementation
*/
    
    public func addDependent (operation: BlockOperation) {
        if let main = main {operation.addDependency(main)}
        if dependentList.contains(operation) {return}
        dependentList.append(operation)
    }
    
    public func start () {
        if main?.isReady ?? true {
            main?.start()
        }
        dependentList.forEach {
            if $0.isReady {$0.start()}
        }
    }
    
}
