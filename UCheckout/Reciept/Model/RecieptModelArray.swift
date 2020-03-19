//
//  RecieptModel.swift
//  UCheckout
//
//  Created by i2i innovation on 05/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct RecieptModelArray: Codable {
    let ack: String?
    let data: [RecieptData]?
    let messsage: String?
    let errors: [CheckOutError]?
}
