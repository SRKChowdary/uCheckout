//
//  ClearCartModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 13/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct ClearCartModel: Codable {
    let message, ack: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case ack = "ack"
    }
}

