//
//  SignInViewModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 08/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct SignInModel: Codable {
    let ack: String?
    let data: [SignInData]?
    let errors: [CheckOutError]?
}

// MARK: - Datum
struct SignInData: Codable {
    let id, email, source, app: String?
    let datumID: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email, source, app
        case datumID = "id"
    }
}
