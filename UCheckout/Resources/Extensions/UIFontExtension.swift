//
//  UIFont+SN.swift
//  ServiceNowAssignment
//
//  Created by i2i innovation on 27/05/19.
//  Copyright © 2019 i2i innovation. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func SNSemiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "SanFranciscoText-Semibold", size: size)!
    }
    class func SNRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "SanFranciscoText-Regular", size: size)!
    }
    
    class func SNBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "SanFranciscoText-Bold", size: size)!
        
        
    }
    
}



