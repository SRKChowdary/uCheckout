//
//  CoreNetworkAlias.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 5/31/19.
//

import Foundation
import ABCoreComponent

public typealias RequestHandler    =   (URLRequest?) -> Result <URLRequest>
public typealias AuthHandler       =   (Closure?) -> Void
public typealias ResponseHandler   =   (Data?, URLResponse?, Error?) -> Void


/// Type alias for representing key value pair
/// - Parameters
///     - key:   String representation
///     - value: String representation
public typealias KV = (String,String)


/** Type alias for Finished closure. Used as a completion closure for services
 - Parameters
 - result: Generic parameter with output of out when success
 
 ### Usage Example: ###
 ````
 didFinish <Out> (_ finished:Finished<Out>)
 ````
 **/
public typealias ResultBlock <Out> = ((Result<Out>) -> Void)

/**
 Type alias to transform input to be used as an output for an another service
 - Parameters
 - input: Generic parameter to be transformed
 - output: Generic paranerer after transformation
 **/
public typealias Transformable = (Encodable) -> Encodable?


public typealias ExtRequestAuthorization = (String?) -> Void
    

    

