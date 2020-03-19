//
//  RefreshTokenRemote.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 5/31/19.
//

import Foundation
import ABCoreNetwork

class RefreshTokenRemoteService {
    
    private var api = APIService <RefreshToken> (named: ServiceType.tokenrefresh.rawValue)
    
    func fetchRemote (sessionToken: String?, client:AuthConfiguration?, completed: @escaping ResultBlock<RefreshToken>) -> APIService <RefreshToken> {
        
        if let client = client, let safeToken = sessionToken {
            api.add(request: request(client: client))
            api.add(method: .POST, data: body(input: safeToken))
            api.inSession(ABNetworkSessionDefault.shared)
            api.then(finished: completed)
        }
        return api
    }
    
    func request (client:AuthConfiguration) -> URLRequest? {
        
        guard let authKey = client.authKey(clientId: client.serviceKey, secret:client.serviceSecret) else {return nil}
        
        var request = ABRequest(
            host: client.serviceHost,
            base: client.serviceBase)
            .make(with: ABHeader.acceptjson,
                  ABHeader.contenturl,
                  LogInUtil.baseAuthHeader(authKey),
                  ABHeader.charset)
        
        RequestConfiguration.noCache(request: &request)
        return request
    }
    
    func body (input:String) -> String {
        return [
            "\(AuthConstants.kRefreshToken)=\(input)",
            AuthConstants.kRefreshGrantType,
            AuthConstants.kScopeOfflineAccess
            ].joined(separator: "&")
    }
    
}
