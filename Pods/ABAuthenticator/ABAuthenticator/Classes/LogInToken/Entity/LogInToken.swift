//
//  LogInToken.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 5/31/19.
//

import Foundation
import ABCoreComponent

public struct LogInToken: Codable {
    var refreshToken, scope, idToken, tokenType: String?
    var expiresIn: Int?
    var accessToken: String?
    var error:String?
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case scope
        case idToken = "id_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case error
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)
        idToken = try container.decodeIfPresent(String.self, forKey: .idToken)
        tokenType = try container.decodeIfPresent(String.self, forKey: .tokenType)
        expiresIn = try container.decodeIfPresent(Int.self, forKey: .expiresIn)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        error = try container.decodeIfPresent(String.self, forKey: .error)
    }
}


public struct Token:Codable, CodableTransform {
    public var refreshToken :String?
    public var accessToken : String?
}

extension LogInToken {
    func savable () -> Data?  {
        let data = self.token?.transformToData()
        return data
    }
    
    //we only want to save this informatipublic on
    public var token:Token? {
        get {
            return Token (refreshToken: self.refreshToken, accessToken: self.accessToken)
        }
    }
}

