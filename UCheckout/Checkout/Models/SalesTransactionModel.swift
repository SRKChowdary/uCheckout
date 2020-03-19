//
//  SalesTransactionModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 09/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct SalesTransactionModel: Codable {
    let ack: String?
    let errors: [CheckOutError]?
}
