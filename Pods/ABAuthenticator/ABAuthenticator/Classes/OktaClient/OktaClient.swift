//
//  OktaClient.swift
//  ECommerce
//
//  Created by Ganesh Reddiar on 5/8/19.
//  Copyright © 2019 Albertsons. All rights reserved.
//

import Foundation
import ABCoreComponent

public struct OktaClient:Codable, CodableTransform {
    
    private static let kBaseSignInPath = "/api/v1/authn"
    var svcName:String?
    var hostName:String?
    var uri:String?
    var clientId:String?
    var clientSecret:String?
    var baseURISignIn = OktaClient.kBaseSignInPath
    
    enum CodingKeys: String, CodingKey {
        case svcName = "svcName"
        case hostName = "hostName"
        case uri = "uri"
        case clientId = "clientId"
        case clientSecret = "clientSecret"
        case baseURISignIn = "baseURISignIn"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        svcName = try container.decodeIfPresent(String.self, forKey: .svcName)
        hostName = try container.decodeIfPresent(String.self, forKey: .hostName)?.replacingOccurrences(of: "https://", with: "")
        uri = try container.decodeIfPresent(String.self, forKey: .uri)
        clientId = try container.decodeIfPresent(String.self, forKey: .clientId)
        clientSecret = try container.decodeIfPresent(String.self, forKey: .clientSecret)
        if let baseURISignIn =  try container.decodeIfPresent(String.self, forKey: .baseURISignIn) {
            self.baseURISignIn = baseURISignIn
        }
    }
    
    public init(from map:[String:String]) {
        svcName = map[CodingKeys.svcName.rawValue]
        hostName = map[CodingKeys.hostName.rawValue]?.replacingOccurrences(of: "https://", with: "")
        uri = map [CodingKeys.uri.rawValue]
        clientId = map [CodingKeys.clientId.rawValue]
        clientSecret = map [CodingKeys.clientSecret.rawValue]
        baseURISignIn = map[CodingKeys.baseURISignIn.rawValue] ??  OktaClient.kBaseSignInPath
    }
    
    public init(svcName: String, hostName: String, uri: String, clientId: String, clientSecret: String) {
        self.svcName = svcName
        self.hostName = hostName
        self.uri = uri
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    func base64ClientAuthKey () -> String? {
        guard let safeSecretID = clientId , let safeSecretValue = clientSecret,
            let data = (safeSecretID + ":" + safeSecretValue).data(using: String.Encoding.utf8) else {
                return nil
        }
        let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    func save () {
        OktaClientLocalStore().save(self)
    }
}

public struct AuthData {
    var user:String?
    var password: String?
    var client: OktaClient?
}

