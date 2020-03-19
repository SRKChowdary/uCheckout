//
//  CreditCardValidator.swift
//  UCheckout
//
//  Created by 1521398 on 02/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

public enum SafewayCardType: String {
    case amex = "Amex"
    case visa = "Visa"
    case masterCard = "MasterCard"
    case discover = "Discover"
    case maestro = "Maestro"
    case dinersClub = "Diners Club"
    case jCB = "JCB"
    case unionPay = "UnionPay"
    case blankCard = "blankCard"
    case mir = "Mir"
}

class CreditCardValidator {
    
    public lazy var types: [CreditCardValidationType] = {
        var types = [CreditCardValidationType]()
        for object in CreditCardValidator.types {
            types.append(CreditCardValidationType(dict: object))
        }
        return types
    }()
    
    public init() { }
    
    /**
     Get card type from string
     
     - parameter string: card number string
     
     - returns: CreditCardValidationType structure
     */
    public func type(from string: String) -> CreditCardValidationType? {
        for type in types {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
            let numbersString = self.onlyNumbers(string: string)
            if predicate.evaluate(with: numbersString) {
                return type
            }
        }
        return nil
    }
    
    /**
     Validate card number
     - parameter string: card number string
     - returns: true or false
     */
    public func validate(string: String) -> Bool {
        let numbers = self.onlyNumbers(string: string)
        if numbers.count < 9 {
            return false
        }
        
        var reversedString = ""
        let range: Range<String.Index> = numbers.startIndex..<numbers.endIndex
        
        numbers.enumerateSubstrings(in: range, options: [.reverse, .byComposedCharacterSequences]) { (substring, substringRange, enclosingRange, stop) -> () in
            reversedString += substring!
        }
        
        var oddSum = 0, evenSum = 0
        let reversedArray = Substring(reversedString)
        for (i, s) in reversedArray.enumerated() {
            
            let digit = Int(String(s))!
            
            if i % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
        }
        return (oddSum + evenSum) % 10 == 0
    }
    
    /**
     Validate card number string for type
     - parameter string: card number string
     - parameter type:   CreditCardValidationType structure
     - returns: true or false
     */
    public func validate(string: String, forType type: CreditCardValidationType) -> Bool {
        return self.type(from: string) == type
    }
    
    public func onlyNumbers(string: String) -> String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = string.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    // MARK: - Loading data
    
    private static let types: [[String: Any]] = [
        [
            "cardType": SafewayCardType.amex,
            "regex": "^3[47][0-9]{13}$"
        ],
        [
            "cardType": SafewayCardType.visa,
            "regex": "^4[0-9]{12}(?:[0-9]{3})?$"
        ],
        [
            "cardType": SafewayCardType.masterCard,
            "regex": "^(5[1-5][0-9]{14}|2[2-7][0-9]{14})$"
        ],
        [
            "cardType": SafewayCardType.maestro,
            "regex": "^(5018|5020|5038|6304|6759|676[1-3])"
        ],
        [
            "cardType": SafewayCardType.dinersClub,
            "regex": "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
        ],
        [
            "cardType": SafewayCardType.jCB,
            "regex": "^(?:2131|1800|35\\d{3})\\d{11}$"
        ],
        [
            "cardType": SafewayCardType.discover,
            "regex": "^6(?:011|5[0-9]{2})[0-9]{12}$"
        ],
        [
            "cardType": SafewayCardType.unionPay,
            "regex": "^62[0-5]\\d{13,16}$"
        ],
        [
            "cardType": SafewayCardType.mir,
            "regex": "^22[0-9]{1,14}$"
        ]
    ]
}

//MARK: - Card Type Image
extension CreditCardValidator {
    func cardTypeAndImageForCardNumber(number: String) -> (cardImage: UIImage?, cardType: SafewayCardType?) {
        guard let type = type(from: number), let image = cardImage(for: type.cardType) else {
            return(UIImage(named:"blankCard.png"), .blankCard)
        }
        return(image, type.cardType)
    }
    
    func cardImage(for cardType: SafewayCardType) -> UIImage? {
        switch cardType {
        case .amex:
            return UIImage(named:"amex.png")
        case .visa:
            return UIImage(named:"visa.png")
        case .masterCard:
            return UIImage(named:"master.png")
        case .discover:
            return UIImage(named:"discover.png")
        default:
            return UIImage(named:"blankCard.png")
        }
    }
}

//MARK: - Validate Entry
extension CreditCardValidator {
    func validCardName(name: String?) -> (isValid: Bool, message: String) {
        let name = name ?? ""
        let isValid = name.count > SafewayWalletConstants.CardRegistration.minimumNameLength
        let message = !isValid ? (name.isEmpty ? "Enter name." : "Enter valid name.") : ""
        return (isValid, message)
    }
    
    func validCardNumber(number: String?, cardType: SafewayCardType) -> (isValid: Bool, message: String) {
        let cardNumber = number ?? ""
        let validCardCount = cardType == .amex ? SafewayWalletConstants.CardRegistration.amexCardNumberLength : SafewayWalletConstants.CardRegistration.otherCardNumberLength
        
        let isValid = cardNumber.count == validCardCount
        let message = !isValid ? (cardNumber.isEmpty ? "Enter card number." : "Enter valid card number.") : ""
        
        return (isValid, message)
    }
    
    func validExpireDate(date: String?) -> (isValid: Bool, message: String) {
        let expireDate = date ?? ""
        let isValid = expireDate.count == SafewayWalletConstants.CardRegistration.expirationDateLength
        let message = !isValid ? (expireDate.isEmpty ? "Enter expiration." : "Enter valid expiration.") : ""
        return (isValid, message)
    }
    
    func validCVVNumber(cvv: String?, cardType: SafewayCardType) -> (isValid: Bool, message: String) {
        let cvvNumber = cvv ?? ""
        let validcvvCount = cardType == .amex ? SafewayWalletConstants.CardRegistration.amexCVVLength : SafewayWalletConstants.CardRegistration.otherCardCvvLength
        
        let isValid = cvvNumber.count == validcvvCount
        let message = !isValid ? (cvvNumber.isEmpty ? "Enter cvv number." : "Enter valid cvv number.") : ""
        
        return (isValid, message)
    }
    
    
    func validZipCode(zipCode: String?) -> (isValid: Bool, message: String) {
        let zipCode = zipCode ?? ""
        let isValid = zipCode.count == SafewayWalletConstants.CardRegistration.zipCodeLength
        let message = !isValid ? (zipCode.isEmpty ? "Enter zipcode." : "Enter valid zipcode.") : ""
        return (isValid, message)
    }
    
}
