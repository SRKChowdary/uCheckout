//
//  RefreshToken.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 5/28/19.
//

import Foundation
import ABCoreNetwork
import ABCoreComponent

public struct RefreshToken: Codable, CodableTransform {
    
    var sessionToken:String?
    var expiresAt:Int?
    var errorCode:String?
    var accessToken:String?
    
    enum CodingKeys: String, CodingKey {
        
        case sessionToken = "refresh_token"
        case expiresAt = "expires_in"
        case accessToken = "access_token"
        case errorCode = "errorCode"
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sessionToken = try container.decodeIfPresent(String.self, forKey: .sessionToken)
        expiresAt = try container.decodeIfPresent(Int.self, forKey: .expiresAt)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        errorCode = try container.decodeIfPresent(String.self, forKey: .errorCode)
    }
    public init () {}
    
    //To support the sync between old and new way 
    public init (map: [String:Any]?) {
            
        sessionToken = map? ["sessionToken"] as? String ?? map? ["refresh_token"] as? String
        if let safeExpirationIntValue = map? ["expiresAt"] as? Int ?? map? ["expires_in"] as? Int {
            expiresAt = safeExpirationIntValue
        }
        errorCode = map? ["errorCode"] as? String
        accessToken = map? ["accessToken"] as? String ?? map? ["access_token"] as? String
    }
}
