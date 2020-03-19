//
//  LogInInteractor.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 6/1/19.
//

import Foundation
import ABCoreNetwork
import ABCoreComponent

class LogInInteractor {
    
    var output :LogInInteractorOuput?
    
    lazy var logInRemote = LogInRemoteStore ()
    lazy var tokenRemote = LogInTokenRemote ()
    
    func signIn (user: UserCredential?, completed: Closure?) {
        
        let client = OktaClientLocalStore().fetch()
        
        let groupAPI = GroupChainAPI<LogInJSON, LogInToken> ()
        let root = logInService(client: client, user: user)
        let node = tokenService(client: client, user: user)
       
        groupAPI.chain(rootService: root, nodeService: node, completed: {completed?()})
        groupAPI.start()
        
    }
    
    func logInService (client: OktaClient?, user: UserCredential?) -> APIService <LogInJSON> {
       
        let logInAPI = logInRemote.fetch(user: user?.name, password: user?.password, client: client, completed: { result in
            switch result {
            case .success(_):
                let logInLocalStore = LogInLocalStore ()
                logInLocalStore.save(user: user)
                self.output?.saveUserCredential(user: user) // TODO: Remove this once keychain has been implemented.
                
            case .failure(let error):
                self.output?.outFailed(error)
                
            }
        })
        return logInAPI
    }
    
    
}


extension LogInInteractor {
    
    func tokenService (client: OktaClient?, user: UserCredential?) -> APIService <LogInToken> {
        
        let tokenService = tokenRemote.fetch(username: user?.name, password: user?.password, client: client) { result in
            switch result {
                case .success(let value):
                    let localStore = LogInTokenLocalStore ()
                    localStore.saveLogInToken(value: value)
                    localStore.setSignedIn()
                    self.output?.saveLogInToken(token: value) // TODO: Remove this once keychain has been implemented.
                    self.output?.outSuccess()
            
            case .failure(let error):
                self.output?.outFailed(error)
            
            }
        }
        return tokenService
    }
}


