//
//  User.swift
//  ECommerce
//
//  Created by Liangzan Chen on 4/12/16.
//  Copyright © 2016 Albertsons. All rights reserved.
//

import UIKit


/// The User class is for storing and retrieving the non-secured information assoicated with a user
class User: NSObject, NSCoding {
    
    // MARK: Properties
    
    var token: String
    var hhid: String?
    var phoneNumber: String?
    var coremaClubCard: String?
    var zipCode: String?
    var guid: String?
    var storeId: String?
    var lastUpdateTime: Date?
    var firstName: String?
    var lastName: String?
    var userId: String?
    var accessToken: String?
    var refreshToken: String?
    
    // MARK: Types:
    struct PropertyKey {
        static let tokenKey = "token"
        static let userIdKey = "userId"
        static let passwordKey = "password"
        static let hhidKey = "hhid"
        static let phoneNumberKey = "phoneNumber"
        static let coremaClubCardKey = "coremaClubCardNumber"
        static let zipCodeKey = "zipCode"
        static let guidKey = "guid"
        static let storeIdKey = "storeID"
        static let lastUpdateTimeKey = "lastUpdateTime"
        static let signedInUserKey = "signedInUser"
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let accessTokenKey = "accessToken"
        static let refreshTokenKey = "refreshToken"
    }
    
    // MARK: Initialization
    init?(  token: String,
            hhid: String?,
            phoneNumber: String?,
            coremaClubCard: String?,
            zipCode: String?,
            guid: String?,
            storeId: String?,
            lastUpdateTime: Date?,
            firstName: String?,
            lastName: String?,
            userId: String?,
            accessToken: String? = nil,
            refreshToken: String? = nil
        ) {
        
        self.token = token
        self.hhid = hhid
        self.phoneNumber = phoneNumber
        self.coremaClubCard = coremaClubCard
        self.zipCode = zipCode
        self.guid = guid
        self.storeId = storeId
        self.lastUpdateTime = lastUpdateTime
        self.firstName = firstName
        self.lastName = lastName
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        super.init()
        
        if token.isEmpty {
            return nil
        }
    }
    
    
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey: PropertyKey.tokenKey)
        aCoder.encode(hhid, forKey: PropertyKey.hhidKey)
        aCoder.encode(phoneNumber, forKey: PropertyKey.phoneNumberKey)
        aCoder.encode(coremaClubCard, forKey: PropertyKey.coremaClubCardKey)
        aCoder.encode(zipCode, forKey: PropertyKey.zipCodeKey)
        aCoder.encode(guid, forKey: PropertyKey.guidKey)
        aCoder.encode(storeId, forKey: PropertyKey.storeIdKey)
        aCoder.encode(lastUpdateTime, forKey: PropertyKey.lastUpdateTimeKey)
        aCoder.encode(firstName, forKey: PropertyKey.firstNameKey)
        aCoder.encode(lastName, forKey: PropertyKey.lastNameKey)
        aCoder.encode(userId, forKey: PropertyKey.userIdKey)
        aCoder.encode(accessToken, forKey: PropertyKey.accessTokenKey)
        aCoder.encode(refreshToken, forKey: PropertyKey.refreshTokenKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let token = aDecoder.decodeObject(forKey: PropertyKey.tokenKey) as! String
        let hhid = aDecoder.decodeObject(forKey: PropertyKey.hhidKey) as? String
        let phoneNumber = aDecoder.decodeObject(forKey: PropertyKey.phoneNumberKey) as? String
        let coremaClubCard = aDecoder.decodeObject(forKey: PropertyKey.coremaClubCardKey) as? String
        let zipCode = aDecoder.decodeObject(forKey: PropertyKey.zipCodeKey) as? String
        let guid = aDecoder.decodeObject(forKey: PropertyKey.guidKey) as? String
        let storeId = aDecoder.decodeObject(forKey: PropertyKey.storeIdKey) as? String
        let lastUpdateTime = aDecoder.decodeObject(forKey: PropertyKey.lastUpdateTimeKey) as? Date
        let firstName = aDecoder.decodeObject(forKey: PropertyKey.firstNameKey) as? String
        let lastName = aDecoder.decodeObject(forKey: PropertyKey.lastNameKey) as? String
        let userId = aDecoder.decodeObject(forKey: PropertyKey.userIdKey) as? String
        let accessToken = aDecoder.decodeObject(forKey: PropertyKey.accessTokenKey) as? String
        let refreshToken = aDecoder.decodeObject(forKey: PropertyKey.refreshTokenKey) as? String
        
        self.init(token: token, hhid: hhid, phoneNumber: phoneNumber, coremaClubCard: coremaClubCard, zipCode: zipCode,
                  guid: guid, storeId: storeId, lastUpdateTime: lastUpdateTime, firstName:firstName, lastName:lastName, userId:userId, accessToken: accessToken, refreshToken:refreshToken)
    }
    
    
}

