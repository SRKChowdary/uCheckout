//
//  OktaAuthenticationSession.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 7/1/19.
//

import Foundation
import ABCoreNetwork
import ABCoreComponent
import JWTDecode

open class OktaAuthenticationSession: AuthenticationSession {
    
    private var config: AuthConfiguration?
    private var tokenRemoteService: RefreshTokenRemoteService?
    private lazy var store = AuthStore ()
    private lazy var authOperation = BlockOperation ()
    private lazy var queue = OperationQueue ()
    
    public static let shared = OktaAuthenticationSession ()
    
    public func setConfig (_ config: AuthConfiguration?) {
        self.config = config
    }
    
    public func authorized<T>(service: APIService<T>) where T : Decodable, T : Encodable {
        guard let token = store.fetchAccessToken() else {return}
        service.addRequest(headers: [AuthHeader.kKey : AuthHeader.kValue(token)])
    }
    
    public func requestAuthorization (completed: Closure?) {
        
        if isValid() {
            completed?()
            return
        }
        
        if authOperation.isReady {
            buildAuthenticationOperation(completed: completed)
            queue.addOperation(authOperation)
        }
        
    }
    
    func buildServiceBlockOperation (completed: Closure?) -> BlockOperation? {
        
        if let serviceBlock = completed {
            let serviceOperation = BlockOperation (block: serviceBlock)
            serviceOperation.addDependency(authOperation)
            queue.addOperation(serviceOperation)
            return serviceOperation
        }
        
        return nil
    }
    
    public func buildAuthenticationOperation (completed: Closure?)  {
        
        let store = AuthStore ()
        let sessionToken = store.fetchSessionToken()
        
        //TODO: Handle if session Token is nil ?
        tokenRemoteService = RefreshTokenRemoteService ()
        self.authOperation = BlockOperation (block: {
            self.tokenRemoteService?.fetchRemote(
                sessionToken: sessionToken,
                client: self.config,
                completed: { result in
                    self.store.saveRefreshToken(result.outSuccess())
                    self.buildServiceBlockOperation(completed: completed)
            }).start()
        })
        
    }
    
    public func isValid () -> Bool {
        
        guard let token = store.fetchAccessToken() else {return false}
        do {
            let jwt = try decode(jwt: token)
            return !jwt.expired
        } catch {
            //
        }
        return false
    }
    
}


