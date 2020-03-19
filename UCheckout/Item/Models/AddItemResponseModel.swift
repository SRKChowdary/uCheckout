//
//  AddItemResponseModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 03/08/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct AddItemResponseModel : Decodable{
    let ack, message, code: String?
    let errors: [CheckOutError]?
}
