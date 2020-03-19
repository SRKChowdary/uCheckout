//
//  LogInTokenLocal.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 6/1/19.
//

import Foundation
import ABCoreComponent

class LogInTokenLocalStore {}

extension LogInTokenLocalStore: LocalStore {
  
    typealias T = Token
    
    func saveLogInToken (value: LogInToken) {
        
        let data = value.savable()
        Store.preference [StoreKey.logintoken.rawValue] = data

    }
    
    func fetch () -> T? {
        
        let storedData: Data? =  Store.preference [StoreKey.token.rawValue]
        return storedData?.transform(type: Token.self)
        
    }
    
    func save(_ object: Token?) {
        Store.preference [StoreKey.token.rawValue] = object
    }
    
    func setSignedIn () {
        Store.preference [StoreKey.signedIn.rawValue] = true
    }
}


