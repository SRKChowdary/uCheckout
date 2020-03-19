//
//  AuthStore.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 7/2/19.
//

import Foundation
import ABCoreComponent

public struct AuthStore {
  
    public init() {}
    
    var notifier: AuthNotifier?
    
    public func saveRefreshToken (_ value : RefreshToken?) {
        guard let tokenData = value?.transformToData() else {return}
        Store.preference [StoreKey.token.rawValue] = tokenData
        notifier?.willSaveRefreshToken(value)
    }
    
    public func fetchSessionToken () -> String? {
        guard let data: Data? = Store.preference[StoreKey.token.rawValue]  else { return nil}
        let token = data?.transform(type: RefreshToken.self)
        return token?.sessionToken
    }
    
    public func fetchAccessToken () -> String? {
        guard let data: Data? = Store.preference[StoreKey.token.rawValue] else { return nil}
        let token = data?.transform(type: RefreshToken.self)
        return token?.accessToken
    }
    
}


public protocol AuthNotifier {
    func willSaveRefreshToken ( _ token: RefreshToken?)
    
}
