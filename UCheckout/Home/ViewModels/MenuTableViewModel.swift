
//
//  MenuTableViewModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 29/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class MenuTableViewModel : NSObject {
    
    public func getMenuData() -> [MenuModel]{
        if let plistDict = Bundle.parsePlist(ofName: "Menu") {
            var scanHelpModelArray = [MenuModel]()
            if let helpScanDataArray = plistDict["menuData"] as? [[String: Any]] {
                for item in helpScanDataArray {
                    scanHelpModelArray.append(MenuModel(item))
                }
            }
            
            return scanHelpModelArray
        }
        else {
            return [MenuModel]()
        }
    }
}
