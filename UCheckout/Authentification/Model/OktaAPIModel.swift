//
//  OktaAPIModel.swift
//  UCheckout
//
//  Created by i2i innovation on 12/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct OktaAPIModel: Codable {
    let tokenType, bearer, accessToken,refreshToken,idToken,scope: String?
    let expiresIn : Double
   
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case bearer = "Bearer"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
        case scope
    }
}
