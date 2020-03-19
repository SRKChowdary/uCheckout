//
//  AuthenticationSession.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 7/1/19.
//

import Foundation
import ABCoreComponent

public protocol AuthenticationSession: class {
    func authorized <T:Codable> (service: APIService<T>)
    func requestAuthorization (completed: Closure?)
}



