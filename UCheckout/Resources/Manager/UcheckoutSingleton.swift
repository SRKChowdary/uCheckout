//
//  UcheckoutSingleton.swift
//  UCheckout
//
//  Created by i2i Innovation on 12/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class UcheckoutSingleton {
    
     static let shared = UcheckoutSingleton()
    
     var getprofileModelData : GetprofileModelData?
     var userData : User?
     var itemElementArray : [ItemElement]?
     var isInStoreRegion : Bool?
     var stores : Stores?
     var viewCart : ViewCartData?
 // Pranav Bug Fix : as per UX Review
    
     private init() { }
}
