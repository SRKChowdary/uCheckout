//
//  LogInError.swift
//  ABAuthentication
//
//  Created by Ganesh Reddiar on 5/12/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation
import ABCoreNetwork
import ABCoreComponent

enum AuthError :String, ABError {    
    
    case incorrectUser = "E0000004"
    case lockedUser = "E00000069"
    case failedAck = "AB00010"
    case passwordExpired = "AB000011"
    case tokenFailure = "AB000012"
    case unknown
    
    init?(code: String) {
        if let error = AuthError(rawValue: code) {
            self = error
        }
        
        self = .unknown
    }
    
}

extension AuthError {
    
    public var friendlyMessageMaker: ([String : String]?) -> String? {
        return { _ in
            self.errorDescription
        }
    }

    public var errorDescription :String {
        switch self {
        case .lockedUser:
            return "User Locked."
        case .incorrectUser:
            return "The email and password you entered do not match our records. Please try again."
        default:
            return "We are having trouble processing this request. Please try again later."
        }
    }
    
    public var code:String {
        switch self {
        case .lockedUser:
            return "E00000069"
        case .incorrectUser:
            return "E0000004"
        default:
            return "Auth-001"
        }
    }
    
}
