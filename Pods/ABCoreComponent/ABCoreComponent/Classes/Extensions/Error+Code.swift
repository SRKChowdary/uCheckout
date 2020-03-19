//
//  Error+Code.swift
//  ABCoreComponent
//
//  Created by Ganesh Reddiar on 7/14/19.
//

import Foundation

public protocol ABError : Error {
    var code:String {get}
    var friendlyMessageMaker : ([String:String]?) -> String? {get}
    
}

public extension Error {
    
    public var code: String {
        if let wrapperError = self as? ABError { return wrapperError.code}
        let nsError = self as NSError
        return String(nsError.code)
    }
}


extension LocalizedError {
    
    func messageWithCode () -> String? {
        let message = "\(localizedDescription) Code: \(code)"
        return message
    }
}
