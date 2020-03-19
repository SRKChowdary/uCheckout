//
//  URLConfig.swift
//  ABAuthentication
//
//  Created by Ganesh Reddiar on 5/17/19.
//  Copyright © 2019 Albertsons Inc. All rights reserved.
//

import Foundation
import ABCoreComponent

public struct AuthConfiguration: ServiceConfiguration {
    
    public var serviceHost: String?
    public var serviceBase: String?
    public var serviceHeaders: [String : String]?

    public var serviceKey: String?
    public var serviceSecret: String?
    
    func authKey (clientId:String?, secret:String?) -> String? {
        guard let safeSecretID = clientId , let safeSecretValue = secret,
            let data = (safeSecretID + ":" + safeSecretValue).data(using: String.Encoding.utf8) else {
                return nil
        }
        let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    public init() {}
    
}




enum ServiceType: String {
    case login
    case logintoken
    case tokenrefresh
}
/**
protocol OktaURL :URLEnvContract {
     func clientId (_ env: Environment) -> String?
     func clientSecret (_ env: Environment) -> String?
     func svcName (_ env: Environment) -> String?
}

extension OktaURL {
    func host (_ env: Environment) -> String? {
        let defaultValue = "abs-qa1.oktapreview.com"
        return [
            Environment.QA1:"abs-qa1.oktapreview.com",
            Environment.QA2:"abs-qa2.oktapreview.com",
            Environment.QA3:"abs-qa3.oktapreview.com",
            Environment.PRODUCTION:"abs-qa1.oktapreview.com"
            ][env] ?? defaultValue
    }
    
    func clientId (_ env: Environment) -> String? {
        return "0oad8aiwt7ZA7sWcz0h7"
    }
    
    func clientSecret (_ env: Environment) -> String? {
        return "thQi8zkx3iRxbJ_l9bNz9G2wnDt9rSqX2fLgrKpW"
    }
    
    func svcName (_ env: Environment) -> String? {
        return "token_endpoint"
    }
}

struct LogInURL :OktaURL {

    func base(_ env: Environment) -> String? {
        return "/api/v1/authn"
    }
    
}

struct LogInTokenURL :OktaURL {
    func base(_ env: Environment) -> String? {
        return "/oauth2/ausdvuyculRIYitXg0h7/v1/token"
    }
}

struct RefreshTokenURL :OktaURL {
    func base(_ env: Environment) -> String? {
        return "/oauth2/ausdvuyculRIYitXg0h7/v1/token"
    }
}
**/
