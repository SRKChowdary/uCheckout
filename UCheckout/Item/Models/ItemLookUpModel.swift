//
//  ItemLookUpModel.swift
//  UCheckout
//
//  Created by i2i innovation on 23/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import ABCoreComponent

// MARK: - Temperatures
struct ItemLookUpModel: Codable ,CodableTransform{
    let ack: String?
    let data: ItemDetail?
    let message: String?
    let errors: [Error]?
//    let jfuOfferCount: Int?
//    let clubPrice : ClubPrices?
    
   // let jfuOfferCount: Int?
    
}

// MARK: - ItemDetail
struct ItemDetail: Codable,CodableTransform {
    let scanCode: String?
    let imageURL: String?
    let id, sku, posDescription: String?
    let itemID: String?
    let extDescription: String?
    let sellMultiple : Int?
    let crv:Double?
    let sellPrice : Double?
    let linkCode: String?
    let foodStamp, restrictedItem, ewic, weightItem: Bool?
    let dept: Int?
    let taxItem, clubItem: Bool?
    let smic: Int?
    let storeID: String?
    let bpn_no: String?
    let jfuOfferCount: Int?
    let clubPrice : ClubPrices?
    
    enum CodingKeys: String, CodingKey {
        case scanCode = "scan_code"
        case imageURL = "image_url"
        case id = "_id"
        case itemID = "item_id"
        case sku
        case posDescription = "pos_description"
        case extDescription = "ext_description"
        case sellMultiple = "sell_multiple"
        case sellPrice = "sell_price"
        case crv
        case linkCode = "link_code"
        case foodStamp = "food_stamp"
        case restrictedItem = "restricted_item"
        case ewic
        case weightItem = "weight_item"
        case dept
        case taxItem = "tax_item"
        case clubItem = "club_item"
        case smic
        case storeID = "store_id"
        case bpn_no
        case jfuOfferCount
        case clubPrice
      
    }
}

// MARK: - Error
struct Error: Codable,CodableTransform {
    let code, message, type, category: String?
    let vendor: String?
}
struct ClubPrices: Codable,CodableTransform
{
    let promoFactor :String?
    let promoMethod : String?
    let promoPrice : Double?
    let promoMaxQty : Int?
    let promoMinQty : Int?
    let offerMessage : String?
    let rawOfferPrice : Double?
}
