//
//  CheckoutModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 02/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import ABCoreComponent

struct CheckoutModel: Codable,CodableTransform {
    let ack: String?
    let data: CheckoutData?
    let message: String?
    let errors: [CheckOutError]?
    
}

// MARK: - DataClass
struct CheckoutData: Codable,CodableTransform {
    let orderID: String?
    let itemDetails: [ItmDetail]?
    let itemCount: Int?
    let checkout, vpos: Bool?
    let deviceID: String?
    let platform, version, clubcardNbr, storeID: String?
    let guid, transactionStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case itemDetails = "item_details"
        case itemCount, checkout, vpos
        case deviceID = "device_id"
        case platform, version
        case clubcardNbr = "clubcard_nbr"
        case storeID = "store_id"
        case guid
        case transactionStatus = "transaction_status"
    }
}

struct ItmDetail: Codable {
    let itemID: String?
    let quantity: Int?
    let upcType, scanCode: String?
    let bagItem: Bool?
    let status: String?
    let weight: Double?
    let weightItem: Bool?
    let text: String?
    let sellPrice: Double?
    let dept, extDescription, posDescription: String?
    let restrictedItem: Bool?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case quantity
        case upcType = "upc_type"
        case scanCode = "scan_code"
        case bagItem = "bag_item"
        case status, weight
        case weightItem = "weight_item"
        case text
        case sellPrice = "sell_price"
        case dept
        case extDescription = "ext_description"
        case posDescription = "pos_description"
        case restrictedItem = "restricted_item"
        case imageURL = "image_url"
    }
}


