//
//  BundleExtension.swift
//  UCheckout
//
//  Created by i2i Innovation on 13/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation


extension Bundle {
    
    class func parsePlist(ofName name: String) -> [String: AnyObject]? {
        
        // check if plist data available
        guard let plistURL = Bundle.main.url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: plistURL)
            else {
                return nil
        }
        
        // parse plist into [String: Anyobject]
        guard let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: AnyObject] else {
            return nil
        }
        
        return plistDictionary
    }
    
    public var shortVersion: String {
        if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
            return ""
        }
    }
    
    public var buildVersion: String {
        if let result = infoDictionary?["CFBundleVersion"] as? String {
            return result
        } else {
            return ""
        }
    }
    
    public var fullVersion: String {
        return "\(shortVersion)(\(buildVersion))"
    }
}
