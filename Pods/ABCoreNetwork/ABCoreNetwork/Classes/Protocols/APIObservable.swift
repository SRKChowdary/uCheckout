//
//  APIObservable.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/9/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation

protocol APIObservable {
    func emit <T:Codable> (service:APIService<T>, result: Result<T>)
}

