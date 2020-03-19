//
//  UPCTypeModel.swift
//  UCheckout
//
//  Created by i2i innovation on 23/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation


public enum UPCType: String {
    case upca = "UPCA"
    case upce = "UPCE"
    case plu = "PLU"
    case gc = "GC"
    case dataBar = "DATABAR"
    case code39 = "code39"
    case code128 = "Code 128"

}

class UPCTypeModel: NSObject {
    
    class func getUPCType(_ symbiology : String)-> String
    {
        if symbiology.contains("UPC-A")
        {
            return UPCType.upca.rawValue
        }
        else if symbiology.contains("UPC-E")
        {
            return UPCType.upce.rawValue
        }
        else if symbiology.contains("Code 128")
        {
            return UPCType.plu.rawValue
        }
        else if symbiology.contains("GS1 DataBar")
        {
            return UPCType.dataBar.rawValue
        }
        else if symbiology.contains("Code 39")
        {
            return UPCType.code39.rawValue
        }
        else
        {
           
            return ""
        }
    }
}
