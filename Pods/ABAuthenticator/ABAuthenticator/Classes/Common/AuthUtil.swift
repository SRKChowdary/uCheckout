//
//  LogInUtil.swift
//  ABAuthentication
//
//  Created by Ganesh Reddiar on 5/12/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation
import ABCoreNetwork

struct LogInUtil {
    
    static func encodedLogin (value:String) -> String? {
        
        var allowedCharactersSet = CharacterSet.urlPathAllowed
        allowedCharactersSet.insert(charactersIn: "!@#$%^&*")
        return value.addingPercentEncoding(withAllowedCharacters: allowedCharactersSet.inverted)
    }
    
    static var baseAuthHeader:(String)-> KV = {(val:String) in
        let key = "Authorization"
        let val =  "Basic \(val)"
        return (key,val)
    }
    
}


