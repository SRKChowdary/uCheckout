//
//  UIImageExtension.swift
//  UCheckout
//
//  Created by i2i Innovation on 08/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

extension UIImage {
    
    static func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
