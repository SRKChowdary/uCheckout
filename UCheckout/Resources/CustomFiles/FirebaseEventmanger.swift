//
//  FireBaseManager.swift
//  UCheckout
//
// 
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import FirebaseAnalytics



class FirebaseEventmanger {
    
    class func logEventWithName (_ name : String , andCustomAttributes attributes:[String:Any]?) {
        Analytics.logEvent(name, parameters: attributes)
        
        
    }
}

