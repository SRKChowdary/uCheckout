//
//  StringExtension.swift
//  UCheckout
//
//  Created by i2i innovation on 19/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

extension String {
    
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
    
    internal func toDouble() -> Double {
        let nsString = self as NSString
        return nsString.doubleValue
    }
    internal func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
    
    func toDate(format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: self)
        return date
    }
    func toShortDate(format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.dateStyle = .short
        let date = formatter.date(from: self)
        return date
    }

    
}
