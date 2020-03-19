//
//  OktaUtility.swift
//  UCheckout
//
//  Created by 1521398 on 04/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//
// Pranav : Changed for DEV implementation :

import Foundation

class OktaUtility: NSObject {
    
    class func isOktaTokenExpired(jwtToken: String) -> Bool {
        return false
    }
    class func getOktaAuthorizationBas64Value() -> String? {
       let clientId = "0oa280cerrIv4ib4w2p7"
        
        // MARK : - DEV -  let clientId = "0oad8aiwt7ZA7sWcz0h7"
        // MARK : - PROD -  let clientId = "0oa280cerrIv4ib4w2p7"
        
        let clientSecret = "LVEMzU7GxHp_jZ3ilfc5a20D9CJgMhuWYn4NkduM"
        
        // MARK : - DEV let clientSecret = "thQi8zkx3iRxbJ_l9bNz9G2wnDt9rSqX2fLgrKpW"
        // MARK : - PROD let clientSecret = "LVEMzU7GxHp_jZ3ilfc5a20D9CJgMhuWYn4NkduM"
        
        let clientIDAndClientSecret: String = clientId + ":" + clientSecret
        guard let data = clientIDAndClientSecret.data(using: String.Encoding.utf8) else {
            return nil
        }
        let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return base64String
        
    }
    
    
    
}
