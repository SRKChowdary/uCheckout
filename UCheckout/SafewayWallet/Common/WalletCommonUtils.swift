//
//  WalletCommonUtils.swift
//  UCheckout
//
//  Created by 1521398 on 07/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation

class WalletCommonUtils {
    static func cardInfo(using cardType: String, alias: String) -> (display: String, image: UIImage?) {
        var display = ""
        var image: UIImage?
        switch cardType.uppercased() {
        case "VISA":
            display = "Visa Credit - \(alias)"
            image = UIImage(named:"visa.png")
        case "MASTERCARD":
            display = "Mastercard Credit - \(alias)"
            image = UIImage(named:"master.png")
        case "DISCOVER":
            display = "Discover Credit - \(alias)"
            image = UIImage(named:"discover.png")
        case "AMEX":
            display = "AMEX Credit - \(alias)"
            image = UIImage(named:"amex.png")
        default:
            display = "Blank"
            image = UIImage(named:"discover.png")
        }
        return(display, image)
    }
    
    //    Validations Pending
    static func uPayStatusPending() -> Bool {
        return false
        return UserDefaults.standard.string(forKey: UPayKeys.uPayStatus)?.caseInsensitiveCompare("Pending") == .orderedSame
    }
}
struct UPayTitles {
    static let authenticationError = "The email and password you entered do not match our records. Please try again."
    static let enrollInUPay = "Enroll in UPay"
    static let uPay = "U Pay"
    // Change made: Added new attribute to make edit button appear on wallet
    //    static let newUPay = "Bank Acct " + (UserDefaults.standard.string(forKey: "UPayAccountNumber") ?? "")
    static let newUPay = "Bank Acct"
}

struct UPayKeys {
    static let uPayStatus = "uPayStatus"
    static let uPayEnabled = "uPayEnabled"
    
}
