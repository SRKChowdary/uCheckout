//
//  OnBoardingModel.swift
//  UCheckout
//
//  Created by i2i innovations on 21/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation


class OnBoardingModel {
    var imageName = ""
    var message = ""
    var header = ""
    
    init(_ plistDict :[String:Any]) {
        if let imageName = plistDict["imageName"] as? String {
            self.imageName = imageName
        }
        if let message = plistDict["message"] as? String {
            self.message = message
        }
        if let header = plistDict["header"] as? String {
            self.header = header
        }
    }
}
