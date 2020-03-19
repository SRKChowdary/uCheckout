//
//  UcheckoutUtils.swift
//  UCheckout
//
//  Created by i2i innovation on 11/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class UcheckoutUtils: NSObject {
    
    class func displayAlertWithMessage(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title:"OK", style: .default, handler: nil))
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(ac, animated: true){}
    }
    
}

