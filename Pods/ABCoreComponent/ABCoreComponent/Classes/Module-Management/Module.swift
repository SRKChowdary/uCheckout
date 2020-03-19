//
//  Module.swift
//  ABCoreComponent
//
//  Created by Ganesh Reddiar on 6/6/19.
//

import Foundation

public typealias ModuleID = String

public protocol Module: class {

    static var moduleID: ModuleID {get}
    static func owner () -> ModuleOwner
}


public protocol ModuleConfiguration  {
    associatedtype T
    static func configuration () -> T?
}



public protocol ServiceConfiguration  {
    
    var serviceHost: String? {get}
    var serviceBase: String? {get}
    var serviceHeaders: [String:String]? {get}
}


public protocol UXConfiguration {}
