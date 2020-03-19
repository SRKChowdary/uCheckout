//
//  CardDetails.swift
//  UCheckout
//
//  Created by 1521398 on 04/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation

struct CardDetails {
    var name: String
    var cardNumber: String
    var cvvNumber: String
    var expirationDate: String
    var zipCode: String
    var cardType: SafewayCardType
}

struct ErrorInfo {
    var title: String
    var description: String
}
