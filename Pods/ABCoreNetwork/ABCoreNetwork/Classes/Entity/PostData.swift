//
//  PostData.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/9/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation

public struct Post  {
    
    public func toData<In>(_ input:In) throws -> Data? {
        if let data = input as? Data {
            return data 
        }
        if let converted = input as? String  {
            return converted.data(using: .utf8)
        }
        return try JSONSerialization.data(withJSONObject: input, options: JSONSerialization.WritingOptions())
    }
}
