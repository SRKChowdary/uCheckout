//
//  ScanHelpModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 13/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class ScanHelpModel: NSObject {
    
    var imageName = ""
    var message = ""
    
    init(_ plistDict :[String:Any]) {
        if let imageName = plistDict["imageName"] as? String {
            self.imageName = imageName
        }
        if let message = plistDict["message"] as? String {
            self.message = message
        }
    }

}
