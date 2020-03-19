//
//  ViewCartModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 17/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//



import Foundation

// MARK: - Welcome
struct ViewCartModel: Codable {
    let ack: String?
    let data: ViewCartData?
    let message: String?
    let errors: [CheckOutError]?
}

// MARK: - DataClass
struct ViewCartData: Codable {
    var items: [ItemElement]?
    var totalQuantity: Int?
    var totalPrice: Double?
    var timeStamp: Int?
   // var orderId: String?
    
    enum CodingKeys: String, CodingKey {
        case items
        case totalQuantity = "total_quantity"
        case totalPrice = "total_price"
        case timeStamp = "time_stamp"
       // case orderId = "order_id"
    }
}

// MARK: - ItemElement
struct ItemElement: Codable {
    var scanCode, upcType: String?
    var quantity: Double?
    var bagItem: Bool?
    let weight: Double?
    var isSelected = false
    var addedTimeStamp, lastUpdatedTimestamp: Int?
    var item: Item?
    
    enum CodingKeys: String, CodingKey {
        case scanCode = "scan_code"
        case upcType = "upc_type"
        case weight
        case quantity
        case bagItem = "bag_item"
        case addedTimeStamp = "added_time_stamp"
        case lastUpdatedTimestamp = "last_updated_timestamp"
        case item
    }
}

// MARK: - ID
struct ID: Codable {
    let oid: String?
    
    enum CodingKeys: String, CodingKey {
        case oid = "$oid"
    }
}

// MARK: - ItemItem
struct Item: Codable {
    var id, itemID, sku, posDescription: String?
    var extDescription: String?
    var sellMultiple: Int?
    var sellPrice: Double?
    var crvItem: Double?
    var linkCode: String?
    var foodStamp, restrictedItem, ewic, weightItem: Bool?
    var dept: Int?
    var taxItem, clubItem: Bool?
    var smic: Int?
    var bpnNo: String?
    var storeID: String?
    var clubPrice: ClubPrice?
    var imageURL: String?
    var jfuOfferCount: Int?
    var item_price: Double?
    var regular_price: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case itemID = "item_id"
        case sku
        case posDescription = "pos_description"
        case extDescription = "ext_description"
        case sellMultiple = "sell_multiple"
        case sellPrice = "sell_price"
        case crvItem = "crv_item"
        case linkCode = "link_code"
        case foodStamp = "food_stamp"
        case restrictedItem = "restricted_item"
        case ewic
        case weightItem = "weight_item"
        case dept
        case taxItem = "tax_item"
        case clubItem = "club_item"
        case smic
        case bpnNo = "bpn_no"
        case storeID = "store_id"
        case clubPrice
        case imageURL = "image_url"
        case jfuOfferCount
        case item_price
        case regular_price
    }
}

struct ClubPrice: Codable {
    let promoFactor : String?
    let promoMinQty : Int?
    let promoMethod : String?
    let rawOfferPrice: Double?
    let promoPrice : Double?
    let promoMaxQty : Int?
    let offerMessage: String?
}


