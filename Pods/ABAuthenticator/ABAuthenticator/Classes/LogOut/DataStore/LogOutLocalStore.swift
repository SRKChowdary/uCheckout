//
//  LogOutLocalStore.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 6/3/19.
//

import Foundation
import ABCoreComponent

class LogOutLocalStore {
    
    func setSignedOut () {
        Store.preference [StoreKey.signedIn.rawValue] = false
    }
}
