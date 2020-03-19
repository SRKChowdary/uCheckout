//
//  GetprofileModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 18/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - Welcome
struct GetprofileModel: Codable {
    let ack, code: String?
    let data: GetprofileModelData?
    let errors: [CheckOutError]?
}

// MARK: - DataClass
struct GetprofileModelData: Codable {
    let sngStoreHours: Bool?
    let customerdetails: Customerdetails?
    let stores: Stores?
    let appSettings: AppSettings?
}

// MARK: - AppSettings
struct AppSettings: Codable {
    let timeout: Timeout?
    let id, scanditLicenseKey, backupScanditKey, oktaClientID: String?
    let oktaSecret, oktaAuthorizationID, platform, version: String?
    let forceUpdateFlag: Bool?
    let app: String?
    let tncURL: String?
    let splTNCURL: String?
    let updateMessage, azureSubscriptionKey, appSettingsID: String?
    
    enum CodingKeys: String, CodingKey {
        case timeout
        case id = "_id"
        case scanditLicenseKey, backupScanditKey
        case oktaClientID = "OKTAClientId"
        case oktaSecret = "OKTASecret"
        case oktaAuthorizationID = "OKTAAuthorizationId"
        case platform, version, forceUpdateFlag, app, tncURL
        case splTNCURL = "splTncURL"
        case updateMessage, azureSubscriptionKey
        case appSettingsID = "id"
    }
}

// MARK: - Timeout
struct Timeout: Codable {
    let timeoutDefault: Double?
    
    enum CodingKeys: String, CodingKey {
        case timeoutDefault = "default"
    }
}

// MARK: - Customerdetails
struct Customerdetails: Codable {
    let itemLimit: Int?
    let userLevel: String?
}

// MARK: - Stores
struct Stores: Codable {
    let name, city, state, postCode: String?
    let address, phoneNumber, latitude, longitude: String?
    let fuelHours, storeID, bagFeePLU: String?
    let storeRadius: Double?
    let userSupportLevel: String?
    let sngEnabled: Bool?
    let sngStoreHours: String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case name, city, state, postCode, address, phoneNumber, latitude, longitude, fuelHours
        case storeID = "storeId"
        case bagFeePLU, storeRadius, userSupportLevel, sngEnabled, sngStoreHours
    }
}




struct CheckOutError: Codable {
    let message, type, vendor, category: String?
}
