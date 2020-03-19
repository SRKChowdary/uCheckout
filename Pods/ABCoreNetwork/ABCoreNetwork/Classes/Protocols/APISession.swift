//
//  APISession.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/9/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation

protocol APISession {
    static var shared:URLSession {get}
}

public struct APISessionDefault:APISession {
    
    public static var shared:URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
}
