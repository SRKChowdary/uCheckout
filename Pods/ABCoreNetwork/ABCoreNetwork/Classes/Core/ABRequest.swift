//
//  ABRequest.swift
//  ABCoreNetwork
//
//  Created by Ganesh Reddiar on 5/9/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation

public struct ABRequest {
    
    /// Supported schemes.
    /// If no value is not provide, the default is set to https
    /// - http
    /// - https
    public enum Scheme:String {
        case secure = "https"
        case unsecure = "http"
    }
    
    /// Scheme - Http or Https .
    /// - Default Value :HTTPS
    private var schemeType:Scheme = .secure
    
    /// Host of the url. Needs to be set.
    /// - Default Value : nil
    /// if no value is provided, ABRequest.url will return nil
    private var host:String?
    
    /// Base path of the url.
    /// The value needs to start from \ or else the ABRequest.url will return nil
    /// - Default Value : nil
    private var base:String?
    
    /// Base path of the url.
    /// The value needs to start from \ or else the ABRequest.url will return nil
    /// - Default Value : nil
    private var path:String?
    
    /// For single query for url. For ex: https://shop.safeway.com/ailses?94104
    /// Here query would be "94104". for Key value pair of query, use queryParams
    private var query:String?
    private var queryParams:[String:String]?
    private var urlRequest: URLRequest?
    
    public init (
        schemeType: Scheme = ABRequest.Scheme.secure,
        host: String? = nil,
        base: String? = nil,
        path: String? = nil,
        query: String? = nil,
        queryParams: [String:String]? = nil
        ) {
        
        self.schemeType = schemeType
        self.host = host
        self.base = base
        self.path = path
        self.query = query
        self.queryParams = queryParams
    }
        
    @discardableResult
    public func make(with header:(k:String, v:String)...) -> URLRequest? {
        var urlRequest = self.make()
        header.forEach {
            urlRequest?.addValue($0.v, forHTTPHeaderField: $0.k)
        }
        return urlRequest
    }
    
    @discardableResult
    public func make(map:[String:String]) -> URLRequest? {
        var urlRequest = self.make()
        map.forEach {
            urlRequest?.addValue($0.value, forHTTPHeaderField: $0.key)}
        return urlRequest
    }
    
    @discardableResult
    public func make (list:[String:String] ...) -> URLRequest? {
        var urlRequest = self.make()
        list.forEach {
            make(map:$0)
        }
        return urlRequest
    }
    
    @discardableResult
    public func make() -> URLRequest? {
        
        var component = URLComponents()
        component.scheme = schemeType.rawValue
        
        guard let safeHost = host else {return nil}
        component.host = safeHost
        component.path = (base ?? "") + (path ?? "")
        
        if let query = query {
            component.query = query
        }
        
        if let queryParams = queryParams {
            component.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: $0.value)}
        }
        
        guard let url = component.url else {return nil}
        return URLRequest(url: url)
    }
    
  
}

public extension URLRequest {
    
    public mutating func acceptJSON () {
        setValue(ABHeader.acceptjson.1, forHTTPHeaderField: ABHeader.acceptjson.0)
        setValue(ABHeader.contenttype.1, forHTTPHeaderField: ABHeader.contenttype.0)
    }
}
