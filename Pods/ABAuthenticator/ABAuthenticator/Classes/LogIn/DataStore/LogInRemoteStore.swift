//
//  LogInService.swift
//  ABAuthentication
//
//  Created by Ganesh Reddiar on 5/17/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation
import ABCoreNetwork
import ABCoreComponent

class LogInRemoteStore {
    
    private var api = APIService <LogInJSON> (named: ServiceType.login.rawValue)
    
    func fetch (user:String?, password:String?, client:OktaClient?, completed:@escaping ResultBlock<LogInJSON>)->  APIService <LogInJSON> {
        guard let client = client else { return api }
        let body = [AuthConstants.kUsernameParam: user, AuthConstants.kPasswordParam: password]

        api.inSession(APISessionDefault.shared)
            .add(request: request(client: client))
            .add(method: APIMethod.POST, data: body)
            .then(validateResponse: dataResponseValidator())
            .then(finished:completed)
        return api
        
    }
    
    func request (client:OktaClient) -> URLRequest? {
        guard let authKey = client.base64ClientAuthKey() else {return nil}
        
        var request = ABRequest(
            host: client.hostName,
            base: client.baseURISignIn)
            .make(with: ABHeader.acceptjson,
                  ABHeader.contenttype,
                  LogInUtil.baseAuthHeader(authKey),
                  ABHeader.charset)
        
        RequestConfiguration.noCache(request: &request)
        return request
    }

}

extension LogInRemoteStore {
    
    private func dataResponseValidator () -> Validator<LogInJSON> {
        
        let block:Validator<LogInJSON> = {json in
            
            if let error = self.hasError(json) {return Result.failure(error)}
            
            let status =  json.status ?? ""
            let ack = LogInJSON.ServerStatus (rawValue: status)
            
            guard let safeAck = ack else {return Result.failure(AuthError.failedAck)}
            
            switch (safeAck) {
                case .success : return Result.success(json)
                case .passwordExpired : return Result.failure(AuthError.passwordExpired)
            }
        }
        return block
    }
    
    private func hasError(_ json:LogInJSON) -> ABError? {
        guard let code = json.errorCode,
            let error = AuthError(code: code) else {return nil}
        return error
    }
    
}








