//
//  AccountModels.swift
//  UCheckout
//
//  Created by i2i Innovation on 02/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct AccountModels: Codable {
    let accounts: [Account]?
    let ack: String?
    let hrLimitReached: Bool?
    let defaultCard: String?
    let applePayFlag: Bool?
    let errors: [CheckOutError]?
}

// MARK: - Account
struct Account: Codable {
    let fdAccountID, type, status: String?
    let credit: Credit?
    let token: Token?
    
    enum CodingKeys: String, CodingKey {
        case fdAccountID = "fdAccountId"
        case type, status, credit, token
    }
}

// MARK: - Credit
struct Credit: Codable {
    let nameOnCard, alias, cardType: String?
    let billingAddress: BillingAddress?
    let expiryDate: ExpiryDate?
}

// MARK: - BillingAddress
struct BillingAddress: Codable {
    let streetAddress, locality, region, postalCode: String?
    let country: String?
}

// MARK: - ExpiryDate
struct ExpiryDate: Codable {
    let month, year, singleValue: String?
}

// MARK: - Token
struct Token: Codable {
    let tokenProvider, tokenID: String?
    let expiryDate: ExpiryDate?
    
    enum CodingKeys: String, CodingKey {
        case tokenProvider
        case tokenID = "tokenId"
        case expiryDate
    }
}
