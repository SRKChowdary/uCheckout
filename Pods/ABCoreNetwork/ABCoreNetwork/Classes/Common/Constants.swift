//
//  Constants.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/11/19.
//

import Foundation


public struct UserMessage {
    
    static let informError = "Our apologies, we're having trouble with our system."
    static let contactSupport = "Please contact support at %@"
    static let genericError = "Network Error"
    
}


public struct RequestConfiguration {
    
    public static func noCache ( request:inout URLRequest?) {
        request?.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request?.httpShouldHandleCookies = false
    }
}
