//
//  FreshLogInTokenService.swift
//  ABAuthentication
//
//  Created by Ganesh Reddiar on 5/17/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation
import ABCoreNetwork
import ABCoreComponent

class LogInTokenRemote {
    
    var api = APIService<LogInToken> (named: ServiceType.logintoken.rawValue)
    
    func fetch (username: String?, password: String? , client: OktaClient?, completed: @escaping ResultBlock<LogInToken>) -> APIService<LogInToken> {
        guard let username = username, let password = password, let client = client else { return api }
        
        api.add(request: request(client: client))
        api.add(method: .POST, data: body(user: username, pwd: password))
        api.inSession(ABNetworkSessionDefault.shared)
        api.then(validateResponse: dataResponseValidator())
        api.then(finished: completed)
        return api
    }
    
    func request (client:OktaClient) -> URLRequest? {
        guard let authKey = client.base64ClientAuthKey() else {return nil}

        var request = ABRequest(
            host: client.hostName,
            base: client.uri)
            .make(with: ABHeader.acceptjson,
                  ABHeader.contenturl,
                  LogInUtil.baseAuthHeader(authKey),
                  ABHeader.charset)
        
        RequestConfiguration.noCache(request: &request)
        return request
    }
    
    func body (user:String, pwd: String) -> String {
        let allowedCharactersSet = CharacterSet.urlPathAllowed
        guard let convUser = user.addingPercentEncoding(withAllowedCharacters: allowedCharactersSet.inverted),
            let convPwd = pwd.addingPercentEncoding(withAllowedCharacters: allowedCharactersSet.inverted) else {return ""}
        
        return [
            "\(AuthConstants.kUsernameParam)=\(convUser)",
            "\(AuthConstants.kPasswordParam)=\(convPwd)",
            AuthConstants.kPasswordGrandType,
            AuthConstants.kScopeOfflineAccess
            ].joined(separator: "&")
    }
}

extension LogInTokenRemote {
    
    private func dataResponseValidator () -> Validator<LogInToken> {
        
        let block:Validator<LogInToken> = {json in
            
            if let error = self.hasError(json) {return Result.failure(error)}
            return Result.success(json)
            
        }
        return block
    }
    
    private func hasError(_ json:LogInToken) -> ABError? {
        guard let code = json.error,
            let error = AuthError(code: code) else {return nil}
        return error
    }
    
}
