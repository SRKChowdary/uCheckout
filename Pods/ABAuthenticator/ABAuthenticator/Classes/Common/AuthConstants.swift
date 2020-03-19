//
//  OktaClientConstants.swift
//  ABAuthentication
//
//  Created by Ganesh Reddiar on 5/17/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation
import ABCoreNetwork

struct AuthConstants {
    
    static let kRefreshToken = "refresh_token"
    static let kRefreshGrantType = "grant_type=refresh_token"
    static let kPasswordGrandType = "grant_type=password"
    static let kScopeOfflineAccess = "scope=openid profile offline_access"
    static let kUsernameParam = "username"
    static let kPasswordParam = "password"
    
}

struct AuthHeader {
    //request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    static let kKey = "Authorization"
    static let kValue = {(val:String) in return "Bearer \(val)"}
}


enum StoreKey: String {
    
    case oktaclient
    case token
    case logintoken
    case signedIn
    
}
