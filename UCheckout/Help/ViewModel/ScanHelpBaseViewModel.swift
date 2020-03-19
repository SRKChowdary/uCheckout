//
//  ScanBaseViewModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 13/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class ScanHelpBaseViewModel: NSObject {
    
    public func getScanHelpBaseData() -> [ScanHelpModel]{
        if let plistDict = Bundle.parsePlist(ofName: "ScanHelp") {
            var scanHelpModelArray = [ScanHelpModel]()
            if let helpScanDataArray = plistDict["scanData"] as? [[String: Any]] {
                for item in helpScanDataArray {
                    scanHelpModelArray.append(ScanHelpModel(item))
                }
            }
            
            return scanHelpModelArray
        }
        else {
            return [ScanHelpModel]()
        }
    }
    
    public func getPLUHelpBaseData() -> [ScanHelpModel]{
        if let plistDict = Bundle.parsePlist(ofName: "PLUHelp") {
            var scanHelpModelArray = [ScanHelpModel]()
            if let helpScanDataArray = plistDict["pluData"] as? [[String: Any]] {
                for item in helpScanDataArray {
                    scanHelpModelArray.append(ScanHelpModel(item))
                }
            }
            
            return scanHelpModelArray
        }
        else {
            return [ScanHelpModel]()
        }
    }
    
    public func getHomeHelpBaseData() -> [ScanHelpModel]{
        if let plistDict = Bundle.parsePlist(ofName: "HomeHelp") {
            var scanHelpModelArray = [ScanHelpModel]()
            if let helpScanDataArray = plistDict["homeData"] as? [[String: Any]] {
                for item in helpScanDataArray {
                    scanHelpModelArray.append(ScanHelpModel(item))
                }
            }
            
            return scanHelpModelArray
        }
        else {
            return [ScanHelpModel]()
        }
    }
}
