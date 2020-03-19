//
//  MenuModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 29/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class MenuModel: NSObject {
    
    var menuImage = ""
    var menuDesc = ""
    
    init(_ plistDict :[String:Any]) {
        if let menuImage = plistDict["menuImage"] as? String {
            self.menuImage = menuImage
        }
        if let menuDesc = plistDict["menuDesc"] as? String {
            self.menuDesc = menuDesc
        }
    }
    
}
