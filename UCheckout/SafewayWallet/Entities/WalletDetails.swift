//
//  WalletDetails.swift
//  UCheckout
//
//  Created by 1521398 on 05/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation

/*
struct WalletDetails: Codable {
    let defaultCard : String
    let ack : String
    let hrLimitReached: String
    let applePayFlag: String
    let accounts : [Accounts]
}

struct Accounts : Codable {
    let credit : Credit
    let fdAccountId : String
    let status : String
    let token : Token
    let type : String
}

struct Credit : Codable {
    let alias : String
    let billingAddress : BillingAddress
    let cardType : String
    let expiryDate : ExpiryDate
    let nameOnCard : String
}

struct Token : Codable {
    let tokenId : String
    let tokenProvider : String
    let tokenType : String
}

struct BillingAddress : Codable {
    let postalCode : String
}

struct ExpiryDate : Codable {
    let month : String
    let year : String
    let singleValue : String
}
*/

class WalletDetails: NSObject {
    var accountArray : [SafewayAccounts]?
    var ack : String?
    var defaultCard : String?
    var applePayFlag : Bool?
    init(responseDict : [String : Any]) {
        if let ack = responseDict["ack"] as? String {
            self.ack = ack
            
        }
        if let defaultCard = responseDict["defaultCard"] as? String {
            self.defaultCard = defaultCard
            
        }
        
        // Apple Pay Flag from the response :
        
        if let applePayFlag = responseDict["applePayFlag"] as? Bool {
            self.applePayFlag = applePayFlag
        }
        if let accountItemArray = responseDict["accounts"] as? [[String:Any]] {
            var accountArrayLocal = [SafewayAccounts]()
            for account in accountItemArray {
                accountArrayLocal.append(SafewayAccounts(accountDict: account))
            }
            self.accountArray = accountArrayLocal
        }
    }
}

class SafewayAccounts : NSObject {
    var fdAccountId : String?
    var type : String?
    var status : String?
    var credit : SafewayCredit?
    var token : SafewayToken?
    init(accountDict : [String : Any]) {
        if let fdAccountId = accountDict["fdAccountId"] as? String {
            self.fdAccountId = fdAccountId
        }
        if let type = accountDict["type"] as? String {
            self.type = type
        }
        if let status = accountDict["status"] as? String {
            self.status = status
        }
        if let credit = accountDict["credit"] as? [String: Any] {
            self.credit = SafewayCredit(creditDict: credit)
        }
        if let token = accountDict["token"] as? [String: Any] {
            self.token = SafewayToken(tokenDict: token)
        }
        
    }
    
}
class SafewayCredit : NSObject {
    var nameOnCard : String?
    var alias : String?
    var cardType : String?
    var billingAddress : SafwayBillingAddress?
    var expiryDate : SafewayExpiryDate?
    
    init(creditDict : [String : Any]) {
        
        if let nameOnCard = creditDict["nameOnCard"] as? String {
            self.nameOnCard = nameOnCard
        }
        if let alias = creditDict["alias"] as? String {
            self.alias = alias
        }
        if let cardType = creditDict["cardType"] as? String {
            self.cardType = cardType
        }
        if let billingAddress = creditDict["billingAddress"] as? [String: Any] {
            self.billingAddress = SafwayBillingAddress(billingDict: billingAddress)
        }
    }
    
}
class SafewayToken : NSObject {
    var tokenProvider : String?
    var tokenId : String?
    var tokenType: String?
    var expiryDate : SafewayExpiryDate?
    
    init(tokenDict : [String : Any]) {
        if let tokenProvider = tokenDict["tokenProvider"] as? String {
            self.tokenProvider = tokenProvider
        }
        if let tokenId = tokenDict["tokenId"] as? String {
            self.tokenId = tokenId
        }
        if let tokenType = tokenDict["tokenType"] as? String {
            self.tokenType = tokenType
        }
        if let expiryDate = tokenDict["expiryDate"] as? [String: Any] {
            self.expiryDate = SafewayExpiryDate(expiryDateDict: expiryDate)
        }
    }
    
}
class SafwayBillingAddress : NSObject {
    var streetAddress : String?
    var locality : String?
    var region : String?
    var postalCode : String?
    var country : String?
    
    init(billingDict : [String : Any]) {
        if let streetAddress = billingDict["streetAddress"] as? String {
            self.streetAddress = streetAddress
        }
        if let locality = billingDict["locality"] as? String {
            self.locality = locality
        }
        if let region = billingDict["region"] as? String {
            self.region = region
        }
        if let postalCode = billingDict["postalCode"] as? String {
            self.postalCode = postalCode
        }
        if let country = billingDict["country"] as? String {
            self.country = country
        }
        
    }
    
}
class SafewayExpiryDate : NSObject {
    var month : String?
    var year : String?
    var singleValue : String?
    
    init(expiryDateDict : [String : Any]) {
        if let month = expiryDateDict["month"] as? String {
            self.month = month
        }
        if let year = expiryDateDict["year"] as? String {
            self.year = year
        }
        if let singleValue = expiryDateDict["singleValue"] as? String {
            self.singleValue = singleValue
        }
    }
}
