//
//  ABServiceError.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/9/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation
import ABCoreComponent

/// Errors that can be thrown from Service Layer
enum ServiceError :ABError {
    
    /// Request is invalid
    case invalidRequest
    
    /// Network Error like Int
    case networkError (Int)
    
    case unsupportedCode
    case osNetworkIssue
    case invalidJSON
    
}


extension ServiceError {
    
    public var code : String {
        switch self {
        case .invalidRequest:
            return "AB0001"
        case .networkError (let status):
            return String(status)
        case .unsupportedCode:
            return "AB0003"
        case .osNetworkIssue:
            return "AB0004"
        case .invalidJSON:
            return "AB0005"
        }
    }
    
    public var message :String? {
        switch self {
        default:
            return "Service Error"
        }
    }

    public var friendlyMessageMaker : ([String:String]?) -> String? {
        return {info in
            let service = info?["service"] ?? UserMessage.genericError
            var message = UserMessage.informError
            if let contact = info?["contact"] {
                message = String (format:"\(message) \(UserMessage.contactSupport)", contact)
            }
            message = "\(message) \n(\(service) - Error Code:\(self.code))"
            return message
        }
    }
  
}
