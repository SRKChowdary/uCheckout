//
//  CreditCardValidationType.swift
//  UCheckout
//
//  Created by 1521398 on 02/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
public func ==(lhs: CreditCardValidationType, rhs: CreditCardValidationType) -> Bool {
    return lhs.cardType == rhs.cardType
}

public struct CreditCardValidationType: Equatable {
    public var cardType: SafewayCardType
    public var regex: String
    
    public init(dict: [String: Any]) {
        if let carType = dict["cardType"] as? SafewayCardType {
            self.cardType = carType
        } else {
            self.cardType = .blankCard
        }
        
        if let regex = dict["regex"] as? String {
            self.regex = regex
        } else {
            self.regex = ""
        }
    }
    
}
