//
//  ABNetworkSession.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/9/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation

public protocol ABNetworkSession {
    static var shared:URLSession {get}
}

public struct ABNetworkSessionDefault:ABNetworkSession {
    
    public static var shared:URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
}

