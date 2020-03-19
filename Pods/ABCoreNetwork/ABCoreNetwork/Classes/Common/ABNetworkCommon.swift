//
//  ABNetworkCommon.swift
//  ABCoreNetwork
//  Has common functions (inside a struct) to be used across this module
//  Version: 1.0, Author : Ganesh Reddiar , Date: 5/9/19
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation

/// Enum for representing Service Result
/// - **success**: success with generic output parameter
/// - **failure**: failure with an instance of error passed as an associated value
///```
///
/// var resultEnum: Result<String> = Result.success("passed");
/// resultEnum = Result.failure(NSError())
///
///```
public enum Result<V> {
    case success(V)
    case failure(Error)
    
    public func outSuccess() -> V? {
        guard case .success (let output) = self else {return nil}
        return output
    }
    
    public func outFailure() -> Error? {
        guard case .failure (let output) = self else {return nil}
        return output
    }
    
    
    public func handle (success:(V)-> Void, failed:(Error)->Void) {
        if let output = outSuccess() {success(output)}
        else if let error = outFailure() {failed(error)}
    }
    
}

/// Configuration of key value pairs to be used as a network header
public struct ABHeader {
    
    /// - key: Content Type
    /// - value: application/json
    public static let contenttype :KV = ("Content-Type","application/json")
    
    /// - key: Accept
    /// - value: application/json
    public static let acceptjson :KV = ("Accept","application/json")
    
    /// - key: charset
    /// - value: utf-8
    public static let charset :KV   = ("charset","utf-8")
    
    /// - key: Content-Type
    /// - value: application/x-www-form-urlencoded
    public static let contenturl  :KV   = ("Content-Type","application/x-www-form-urlencoded")
    
    public static let json = [
        ABHeader.contenttype.0 :ABHeader.contenttype.1,
        ABHeader.acceptjson.0 :ABHeader.acceptjson.1
    ]
    
}


/// Methods supported as a part of the API Protocol.
/// This governs the data to be set when sending the request
public enum APIMethod:String {
    case GET
    case POST
    case DELETE
    case PUT
    case PATCH
}


/// Enum stating the current status of the service
public enum APIServiceStatus {
    case ready
    case running
    case finished
}


