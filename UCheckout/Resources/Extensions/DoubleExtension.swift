//
//  DoubleExtension.swift
//  UCheckout
//
//  Created by i2i Innovation on 18/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

 extension Double {
    static let nearbyDistance: Double = 150.00
    
        /// Rounds the double to decimal places value
        func rounded(toPlaces places:Int) -> Double {
            let divisor = pow(10.0, Double(places))
            return (self * divisor).rounded() / divisor
        }
    
}
