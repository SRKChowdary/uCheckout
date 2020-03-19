//
//  OktaClientLocalStore.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 6/2/19.
//

import Foundation
import ABCoreComponent

open class OktaClientLocalStore : LocalStore {
   
    public typealias T = OktaClient

    public init() {}
    public func fetch() -> OktaClient? {
        let data: Data? = Store.preference [StoreKey.oktaclient.rawValue]
        let client = data?.transform(type: OktaClient.self)
        return client
    }
    
    public func save(_ object: OktaClient?) {
        let storable = object?.transformToData()
        Store.preference [StoreKey.oktaclient.rawValue] = storable
    }
    
    public func save(map:[String:String]) {
        let client = OktaClient(from:map)
        Store.preference [StoreKey.oktaclient.rawValue] = client

    }
}
