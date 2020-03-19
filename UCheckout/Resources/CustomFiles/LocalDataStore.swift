//
//  LocalDataStore.swift
//  UCheckout
//
//  Created by i2i innovation on 26/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class LocalDataStore {
    
    class func saveValue(_ value : Any , _ key : String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func retrieveValue (_ key : String) -> Any? {
        if let value = UserDefaults.standard.value(forKey: key) {
            return value
        }
        return nil
    }
    
    class func signoutUser(){
        UserDefaults.standard.set(nil, forKey: UserDefaultConstants.Password)
         UserDefaults.standard.set(nil, forKey: UserDefaultConstants.UserName)
    }
}
