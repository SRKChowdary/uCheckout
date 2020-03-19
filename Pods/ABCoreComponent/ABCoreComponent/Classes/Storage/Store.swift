//
//  Store.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 5/25/19.
//

import Foundation

open class Store {
    public static let preference = PreferenceStore ()
    public static let session = SessionStore ()
}


public protocol LocalStore  {
    associatedtype T
    
    func fetch () -> T?
    func save (_ object :T?)
    
}
