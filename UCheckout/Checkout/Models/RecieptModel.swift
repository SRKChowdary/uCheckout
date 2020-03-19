//
//  RecieptModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 03/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
struct RecieptModel: Codable {
    let ack: String?
    let data: RecieptData?
    let messsage: String?
    let errors: [CheckOutError]?
}

// MARK: - DataClass
struct RecieptData: Codable {
    let id: RecieptID?
    let totalAmount: Double?
    let terminalNumber, platform, retrieveBarcodeSymbology: String?
    let receiptJSON: ReceiptJSON?
    let storeID, deviceID, receipt, orderID: String?
    let transactionID, version, retrieveBarcodeValue, transactionStatus: String?
    let storeTime: String?
    let itemCount: Int?
    let storeAddress: String?
    let lineItemTypeCount: Int?
    let guid: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case totalAmount = "total_amount"
        case terminalNumber = "terminal_number"
        case platform
        case retrieveBarcodeSymbology = "retrieve_barcode_symbology"
        case receiptJSON = "receipt_json"
        case storeID = "store_id"
        case deviceID = "device_id"
        case receipt
        case orderID = "order_id"
        case transactionID = "transaction_id"
        case version
        case retrieveBarcodeValue = "retrieve_barcode_value"
        case transactionStatus = "transaction_status"
        case storeTime = "store_time"
        case itemCount = "item_count"
        case storeAddress = "store_address"
        case lineItemTypeCount, guid
    }
}

// MARK: - ID
struct RecieptID: Codable {
    let oid: String?
    
    enum CodingKeys: String, CodingKey {
        case oid = "$oid"
    }
}

// MARK: - ReceiptJSON
struct ReceiptJSON: Codable {
    let footer: String?
    let receiptItemDetailsList: [ReceiptItemDetailsList]?
    let transactionInfo: TransactionInfo?
    let storeTime: String?
    let receiptTotalResult: ReceiptTotalResult?
    let userID, orderID, header, storeAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case footer, receiptItemDetailsList, transactionInfo, storeTime, receiptTotalResult
        case userID = "userId"
        case orderID = "orderId"
        case header
        case storeAddress = "store_address"
    }
}

// MARK: - ReceiptItemDetailsList
struct ReceiptItemDetailsList: Codable {
    let extendedPrice: Double?
    let deliveredQty, departmentNumber, shortDescription, itemType: String?
    let unitPrice: Double?
    let itemID, departmentName: String?
    
    enum CodingKeys: String, CodingKey {
        case extendedPrice, deliveredQty, departmentNumber, shortDescription, itemType, unitPrice
        case itemID = "itemId"
        case departmentName
    }
}

// MARK: - ReceiptTotalResult
struct ReceiptTotalResult: Codable {
    let total: Double?
    let j4UCouponsSavings: Double?
    let totalSavings: Double?
    let tax: Double?
    let subTotal: Double?
    let clubCardSavings: Double?
    
    enum CodingKeys: String, CodingKey {
        case total
        case j4UCouponsSavings = "j4uCouponsSavings"
        case totalSavings, tax, subTotal, clubCardSavings
    }
}

// MARK: - TransactionInfo
struct TransactionInfo: Codable {
    let terminalNumber, transactionStatus, cardPanPrint, approvalNumber: String?
    let cardType: String?
    let transactionCompleteAt: String?
    let transactionID: String?
    
    enum CodingKeys: String, CodingKey {
        case terminalNumber = "terminal_number"
        case transactionStatus = "transaction_status"
        case cardPanPrint = "card_pan_print"
        case approvalNumber = "approval_number"
        case cardType = "card_type"
        case transactionCompleteAt = "transaction_complete_at"
        case transactionID = "transaction_id"
    }
}
